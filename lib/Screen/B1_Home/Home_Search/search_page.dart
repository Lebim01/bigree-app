import 'dart:async';

import 'package:event_country/Library/loader_animation/dot.dart';
import 'package:event_country/Library/loader_animation/loader.dart';
import 'package:event_country/Screen/B1_Home/Home_Search/searchBoxEmpty.dart';
import 'package:event_country/utils/models.dart';
import 'package:flutter/material.dart';

import 'package:event_country/utils/lang/lang.dart' as Lang;
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:event_country/utils/widgets/eventDetail.dart' as eventDetail;

final lang = Lang.Lang();

class searchPage extends StatefulWidget {
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController _addNameController;
  String searchString = '';

  bool load = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        load = false;
      });
    });
    _addNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          lang.search,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19.0,
              color: Colors.black54,
              fontFamily: "Sofia"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 20.0, right: 50.0),
              child: Text(
                lang.whatWouldSearch,
                style: TextStyle(
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                    fontSize: 27.0,
                    color: Colors.black54,
                    fontFamily: "Sofia"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, right: 20.0, left: 20.0, bottom: 20.0),
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15.0,
                          spreadRadius: 0.0)
                    ]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 10.0,
                    ),
                    child: Theme(
                      data: ThemeData(hintColor: Colors.transparent),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            searchString = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.search,
                              color: Colors.black38,
                              size: 28.0,
                            ),
                            hintText: lang.search,
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Graphql.Query(
              options: Graphql.QueryOptions(
                documentNode: Graphql.gql("""
                  query search(\$searchString: String){
                    events(search: \$searchString) {
                      id
                      title
                      description
                      price
                      location
                      image
                      date
                      capacity

                      UserEvents {
                        User {
                          name
                          email
                          image
                        }
                      }
                    }
                  }
                """),
                variables: {
                  'searchString': searchString
                }
              ),
              builder: (Graphql.QueryResult result, { VoidCallback refetch, Graphql.FetchMore fetchMore }) {
                if (result.hasException) return Text('Error: ${result.exception.toString()}');

                if (searchString == null)
                  return searchBoxEmpty();

                if (searchString.trim() == "")
                  return searchBoxEmpty();

                if (result.loading) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 110.0),
                    child: Center(
                        child: ColorLoader5(
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.blueAccent,
                      dotThreeColor: Colors.green,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 1),
                    )),
                  );
                }

                List data = result.data['events'];
                
                if(data.length == 0) return noItem();
                
                return Column(
                  children: data.map((row) {
                    Event event = Event(row);
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0, 
                        right: 20.0, 
                        top: 15.0, 
                        bottom: 5.0
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => eventDetail.EventDetailScreen(event.id),
                              transitionDuration: Duration(milliseconds: 600),
                              transitionsBuilder: (_,
                                  Animation<double> animation,
                                  __,
                                  Widget child) {
                                return Opacity(
                                  opacity: animation.value,
                                  child: child,
                                );
                              }
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Hero(
                                tag: 'hero-tag-${event.id}',
                                child: Material(
                                  child: Container(
                                    height: 180.0,
                                    width: 120.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(event.image),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 174.0,
                                      child: Text(
                                        event.title,
                                        style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 16.0,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: 150.0,
                                          child: Text(
                                            event.location,
                                            style: TextStyle(
                                              fontFamily: "Sofia",
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 16.0,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: 150.0,
                                          child: Text(
                                            event.dateFormated,
                                            style: TextStyle(
                                              fontFamily: "Sofia",
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.credit_card,
                                          size: 16.0,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          event.price.toString(),
                                          style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList()
                );
              }
            )
          ]
        )
      )
    );
  }
}


///
///
/// If no item cart this class showing
///
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
                    EdgeInsets.only(top: mediaQueryData.padding.top + 30.0)),
            Image.asset(
              "assets/image/searching.png",
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "No Matching Views ",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.5,
                  color: Colors.black26.withOpacity(0.3),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
