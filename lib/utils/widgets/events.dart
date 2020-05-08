
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:shimmer/shimmer.dart';
import 'package:event_country/utils/widgets/eventDetail.dart' as eventDetail;
import 'package:event_country/utils/models.dart' as models;

String queryAllEventList = """
  {
    events {
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

class peopleJoinEvent extends StatelessWidget {

  peopleJoinEvent({this.people});

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
      child: new peopleJoinEvent(people: this.people)
    );
  }
}

Widget cardHeaderLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Container(
      height: 390.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 0.5)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.black38,
        highlightColor: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Container(
                height: 210.0,
                width: 180.0,
                decoration: BoxDecoration(color: Colors.black12, boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 0.2,
                      blurRadius: 0.5)
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 18.0,
                        width: 130.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 13.0,
                      ),
                      Container(
                        height: 15.0,
                        width: 105.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 13.0,
                      ),
                      Container(
                        height: 15.0,
                        width: 105.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _loadingDataHeader(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: 8,
    itemBuilder: (context, i) {
      return cardHeaderLoading(context);
    },
  );
}

class cardDataFirestore extends StatelessWidget {
  
  cardDataFirestore({this.list});

  final List list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: list.length,
        itemBuilder: (context, i) {

          models.Event event = models.Event(list[i]);

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new eventDetail.EventDetailScreen(event.id),
                  transitionDuration: Duration(milliseconds: 600),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }
                )
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'hero-tag-${event.id}',
                    child: Material(
                      child: Container(
                        height: 390.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(
                                image: NetworkImage(event.image),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  spreadRadius: 0.2,
                                  blurRadius: 0.5)
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Container(
                      width: 210.0,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            spreadRadius: 0.2,
                            blurRadius: 0.5)
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              event.title,
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              event.location,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 4.0),
                            /*Text(
                              date,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),*/
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 3.0, bottom: 30.0),
                                child: BubblePeopleJoinEvent(event.userEvents)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class AllEventListScreen extends StatefulWidget {
  AppBar appBar;

  AllEventListScreen({Key key, this.appBar}) : super(key: key);

  @override
  _allEventsListStateScreen createState() => _allEventsListStateScreen(this.appBar);
}

class _allEventsListStateScreen extends State<AllEventListScreen> {

  AppBar appBar;

  _allEventsListStateScreen(this.appBar);

  @override
  bool loadImage = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: this.appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: AllEventList()
              )
            ]
          )
        )
      )
    );
  }
}

class AllEventList extends StatefulWidget {
  @override
  _allEventsListState createState() => _allEventsListState();
}

class _allEventsListState extends State<AllEventList> {

  _allEventsListState();

  @override
  bool loadImage = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Graphql.Query(
      options: Graphql.QueryOptions(
        documentNode: Graphql.gql(queryAllEventList),
      ),
      builder: (Graphql.QueryResult result, { VoidCallback refetch, Graphql.FetchMore fetchMore }) {
        if (result.loading) {
          return _loadingDataHeader(context);
        } else if(result.hasException) {
          return Text(result.exception.toString());
        } else {
          List events = result.data['events'];

          if (events.length == 0) {
            return _loadingDataHeader(context);
          } else {
            return new cardDataFirestore(
              list: events,
            );
          }
        }
      },
    );
  }
}