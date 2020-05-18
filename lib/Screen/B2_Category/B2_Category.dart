import 'dart:async';

import 'package:event_country/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Germany/germany.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:event_country/graphql.dart' as myGraphql;
import 'package:event_country/utils/lang/lang.dart' as Lang;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

final lang = Lang.Lang();

var _data;

class Category extends StatefulWidget {
  String token;
  Category({this.token}); 
  _CategoryState createState() => _CategoryState();
  
}

Future<String> getCategories() async {
  Graphql.QueryOptions queryOptions = Graphql.QueryOptions(
    documentNode: Graphql.gql("""
        query categories {
          categories {
            id
            name
            image
          }
        }
    """)
  );

  Graphql.QueryResult queryResult = await myGraphql.getGraphQLClient().query(queryOptions);
  if(queryResult.hasException){
    throw queryResult.exception.graphqlErrors[0].message;
  }

  _data = queryResult.data;
  return queryResult.data.toString();
}

class _CategoryState extends State<Category> {

  @override
  Widget build(BuildContext context) {
    getCategories();
    
    var _appbar = AppBar(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          lang.category,
          style: TextStyle(
              fontFamily: "Gotik",
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new searchPage()
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Icon(
              Icons.search,
              size: 27.0,
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
    
    if(_data != null){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbar,
        body :  ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _data["categories"].length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 180,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new germany(
                                  userId: widget.token,
                                  nameAppbar: _data["categories"][index]["name"],
                                )));
                      },
                      child: itemCard(
                          image:  _data["categories"][index]["image"],
                          title:  _data["categories"][index]["name"])),
                ],
              ),
            
            );
          },
        )      
      );
    } else {
      Timer(Duration(seconds: 2), () {
        setState(() {
          _CategoryState();
        });
      });

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbar,
        body: SingleChildScrollView(
          child: Center(child: Loading(indicator: BallPulseIndicator(), size: 150.0,color: Colors.purple[100]))
        ),
      );
    }
  }
}

class itemCard extends StatelessWidget {
  String image, title;
  itemCard({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: Container(
        height: 140.0,
        width: 400.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              image:
                  DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFABABAB).withOpacity(0.7),
                  blurRadius: 4.0,
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.black12.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w800,
                    fontSize: 39.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
