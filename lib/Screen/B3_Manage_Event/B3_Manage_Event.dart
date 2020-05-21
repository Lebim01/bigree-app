import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_country/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:event_country/models/evnets_models.dart';

import 'Manage_Event_Detail.dart';

import '../../utils/lang/lang.dart' as Lang;

final lang = Lang.Lang();

class favorite extends StatefulWidget {
  String uid;
  favorite({this.uid});

  _favoriteState createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  String token = '';

  SharedPreferences prefs;

  final events = new List<EventModel>();
  EventModel eventModel = new EventModel();

  bool loadImage = true;
  final eventsServices = new EventsServices();
  @override
  void initState() {
    super.initState();
    cargarPref();
  }

  cargarPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    print(token);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            lang.manageEvent,
            style: TextStyle(
              fontFamily: "Popins",
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      body: _getEvents(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'createEvent'),
      ),
    );
  }

  Widget _getEvents() {
    return FutureBuilder(
      future: eventsServices.getEvents(token),
      //initialData: InitialData,
      builder:
          (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          final events = snapshot.data;
          //print(snapshot.data);
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) => _loadingCard(context, events[i]),
          );
          //return Center(child: Text('${events[0]['id']}'));
          //return Container();
          // return loadingCard( context, );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, EventModel events) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          //Borrar producto
        },
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('${events.title} - ${events.description}'),
                subtitle: Text(events.id),
                onTap: () => Navigator.pushNamed(context, 'createEvent',
                    arguments: events),
              ),
            ],
          ),
        ));
  }

  Widget _loadingCard(BuildContext ctx, EventModel event) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(ctx, 'createEvent', arguments: event),
          child: Container(
            height: 250.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 3.0,
                      spreadRadius: 1.0)
                ]),
            child: Column(children: [
              Container(
                height: 165.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () {
                      eventsServices.getEvent(token, event.id).then((value) {
                        if (value == 0) {
                          print('no tiene nada');
                          _dialog(context, "Está seguro que desea cancelar este evento?");
                        }
                        if (value == 1) {
                           _dialog(context, "Lo sentimos, este evento no puede ser cancelado");
                        }
                        if (value == 2) {
                          print('solo tiene usuarios');
                          _mostrarAlert(context);
                        }
                      });
                      
                    },
                    child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.delete,
                          color: Colors.black38,
                        )),
                  ),
                ),
                alignment: Alignment.topRight,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${event.title}',
                            style: TextStyle(
                              fontFamily: "Popins",
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Icon(
                                  Icons.place,
                                  size: 17.0,
                                ),
                                Container(
                                    width: 120.0,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Text(
                                          '${event.location}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: "popins",
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black38),
                                          overflow: TextOverflow.ellipsis,
                                        )))
                              ]),
                              Row(children: <Widget>[
                                Icon(
                                  Icons.timer,
                                  size: 17.0,
                                ),
                                Container(
                                    width: 160.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        '${event.timeStart.substring(0, 5)} - ${event.timeEnd.substring(0, 5)}',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "popins",
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black38),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                              ]),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  _dialog(BuildContext context, string) {
    return showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.network(
                "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                fit: BoxFit.cover,
              ),
              title: Text(string,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Gotik",
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)),
              entryAnimation: EntryAnimation.TOP_RIGHT,
              onOkButtonPressed: () {
                // Navigator.pop(context);

                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text("Cancel event "),
                //   backgroundColor: Colors.red,
                //   duration: Duration(seconds: 3),
                // ));
              },
            ));
  }
  void _mostrarAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Ingrese el motivo por el cual desea cancelar este evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTitle()
            ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: ()=> Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                )
            ],
        );
      }
    );
  }

  Widget _createTitle(){
    return  TextFormField(
      initialValue: eventModel.title,
      keyboardType: TextInputType.text,
      textCapitalization:
      TextCapitalization.words,
      maxLines: 4,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold",
          fontSize: 18.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Ingrese el motivo',
        hintStyle: TextStyle(
            fontFamily: "Sofia",
            fontSize: 15.0),
      ),
      /////get data
      onSaved: (value) => eventModel.title = value,
      validator: (value){
        if(value.length < 3){
          return 'Ingrese el titulo ';
        }else return null;
      },
    );
  }
  

}

class noItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 80.0)),
            Image.asset(
              "assets/image/IlustrasiCart.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "Haven't Joined Event",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 19.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
