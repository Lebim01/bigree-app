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
  String motivo = '';
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
            itemBuilder: (context, i) => _loadingCard2(context, events[i]),
          );
          //return Center(child: Text('${events[0]['id']}'));
          //return Container();
          // return loadingCard( context, );
        }
      },
    );
  }

 

  Widget _loadingCard2(BuildContext ctx, EventModel event) {
     return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
          child: InkWell(
              onTap: () {
                 Navigator.pushNamed(ctx, 'createEvent', arguments: event);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.2),
                            spreadRadius: 3.0,
                            blurRadius: 10.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Hero(
                        tag: 'hero-tag-list-${event.id}',
                        child: Material(
                          child: Container(
                            height: 165.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(event.image), fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 10.0),
                              child: InkWell(
                                onTap: () {
                                    eventsServices.getEvent(token, event.id).then((value) {
                                      if (value == 0) {
                                        print('no tiene nada ${event.id}');
                                        _dialog(
                                            context,
                                            "Está seguro que desea cancelar este evento?",
                                            1,
                                            event.id);
                                      }
                                      if (value == 1) {
                                        _dialog(
                                            context,
                                            "Lo sentimos, este evento no puede ser cancelado",
                                            0,
                                            event.id);
                                      }
                                      if (value == 2) {
                                        print('solo tiene usuarios ${event.id}');
                                        _mostrarAlert(context, event.id);
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 13.0, top: 7.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Text(
                              event.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0,
                                  fontFamily: "Popins"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      size: 17.0,
                                    ),
                                    Container(
                                        width: 120.0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              event.location,
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
                                        width: 140.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            event.timeEnd,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
  }



  _dialog(BuildContext context, string, int cancel, id) {
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
                if (cancel == 1) {
                  eventsServices.cancelEvent(token, id, '').then((resp) {
                    if (resp == null) {
                      print('este evento ya ha sido cancelado');
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      print('evento cancelado');
                      setState(() {
                        _getEvents();
                      });
                      //_getEvents();
                    }
                  });
                }
                // Navigator.pop(context);

                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text("Cancel event "),
                //   backgroundColor: Colors.red,
                //   duration: Duration(seconds: 3),
                // ));
              },
            ));
  }

  void _mostrarAlert(BuildContext context, id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(
                'Ingrese el motivo por el cual desea cancelar este evento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[_createTitle()],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  print(motivo);
                  eventsServices.cancelEvent(token, id, motivo).then((resp) {
                    if (resp == null) {
                      print('este evento ya ha sido cancelado');
                      Navigator.of(context).pop();
                    } else {
                      print('evento cancelado');
                      setState(() {
                        _getEvents();
                      });
                      Navigator.of(context).pop();
                      //_getEvents();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Widget _createTitle() {
    return TextFormField(
      initialValue: motivo,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      maxLines: 4,
      style: TextStyle(
          fontFamily: "WorkSofiaSemiBold", fontSize: 18.0, color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Ingrese el motivo',
        hintStyle: TextStyle(fontFamily: "Sofia", fontSize: 15.0),
      ),
      /////get data
      onChanged: (valor) {
        setState(() {
          motivo = valor;
        });
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
