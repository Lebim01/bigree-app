import 'package:flutter/cupertino.dart';

import 'package:event_country/utils/lang/lang.dart' as Lang;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:event_country/utils/widgets/eventDetail/buttonPay.dart' as buttonPay;
import 'package:event_country/utils/widgets/sliver.dart' as sliver;
import 'package:event_country/utils/models.dart' as models;

final lang = Lang.Lang();

String queryEvent = """
  {
    event(id: \$id){
      id
      title
      description
      price
      location
      image
      date

      UserEvents {
        User {
          name
          email
          image
        }
      }
    }
  }
""";

class PeopleJoinEvent extends StatelessWidget {

  PeopleJoinEvent({this.people});

  final List people;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              height: 35.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: this.people.length > 3 ? 3 : this.people.length,
                itemBuilder: (context, i) {
                  String _img = this.people[i]['User']['image'];

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: NetworkImage(_img),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, left: 135.0),
          child: Text(
            people.length.toString() + " People Join",
            style: TextStyle(fontFamily: "Popins"),
          ),
        )
      ],
    );
  }
}

class BubblePeopleJoinEvent extends StatelessWidget {

  List people;

  BubblePeopleJoinEvent(
    this.people
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
      child: new PeopleJoinEvent(people: this.people)
    );
  }
}

class ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, left: 25.0, right: 30.0),
      child: Divider(
        color: Colors.black12,
        height: 2.0,
      ),
    );
  }
}

class ListItem extends StatelessWidget {

  String title = '';
  String subtitle = '';
  Widget icon_empty = Icon(
    Icons.title,
    color: Colors.transparent,
  );
  Widget icon;

  ListItem({
    @required this.title,
    this.subtitle,
    this.icon
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: Row(
        children: <Widget>[
          this.icon == null ? this.icon_empty : this.icon,
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: "Popins"),
                ),
                Text(
                  this.subtitle,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListSimpleItem extends StatelessWidget {

  String text;

  ListSimpleItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
      child: Text(
        this.text,
        style: TextStyle(
            fontFamily: "Popins",
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  
  int idEvent;

  EventDetailScreen(this.idEvent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: 
          Graphql.Query(
            options: Graphql.QueryOptions(
              documentNode: Graphql.gql(queryEvent),
              variables: {
                'id': this.idEvent,
              }
            ),
            builder: (Graphql.QueryResult result, { VoidCallback refetch, Graphql.FetchMore fetchMore }) {
              if (result.hasException) {
                  return Text(result.exception.toString());
              }

              if (result.loading) {
                return Text('Loading');
              }

              models.Event event = models.Event(result.data['event']);
              return detailScreen(context, event);
            },
          )
      ),
    );
  }
}

Widget detailScreen(context, event){
  double _height = MediaQuery.of(context).size.height;
  return Stack(
    children: <Widget>[
      CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: sliver.MySliverAppBar(
              expandedHeight: _height - 40.0,
              img: event.image,
              title: event.title,
              id: event.id
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                /* FOTO DEL EVENTO
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("Loading");
                    } else {
                      var userDocument = snapshot.data;
                      _nama = userDocument["name"];
                      _photoProfile = userDocument["photoProfile"];
                    }

                    var userDocument = snapshot.data;
                    return Container();
                  },
                ),*/

                /** TITULO */
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontFamily: "Popins"
                    ),
                  ),
                ),

                /** FECHA Y HORA */
                ListItem(
                  title: event.date,
                  subtitle: event.time,
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black26,
                  )
                ),

                ListDivider(),

                /** UBICACIÓN */
                ListItem(
                  title: lang.location, 
                  subtitle: event.location,
                  icon: Icon(
                    Icons.place,
                    color: Colors.black26
                  )
                ),

                ListDivider(),

                /** PRECIO */
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.payment,
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          event.price.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: "Popins"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ListDivider(),

                /** CIRCULO CON LAS PERSONAS QUE ASISTEN A ESTE EVENTO */
                BubblePeopleJoinEvent(event.userEvents),

                SizedBox(
                  height: 30.0,
                ),

                Container(
                  height: 20.0,
                  width: double.infinity,
                  color: Colors.black12.withOpacity(0.04),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Text(
                    lang.about,
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: "Popins"
                    ),
                  ),
                ),

                /** DESCRIPCION */
                ListSimpleItem(event.description),

                SizedBox(
                  height: 100.0,
                )
              ]
            )
          ),
        ],
      ),

      /** BARRA DE ABAJO */
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70.0,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              /** PRECIO */
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  event.price.toString(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 19.0,
                    fontFamily: "Popins"
                  ),
                ),
              ),

              /** BOTON DE PAGAR */
              buttonPay.ButtonPay(event.id)
            ],
          ),
        ),
      ),
    ]
  );
}