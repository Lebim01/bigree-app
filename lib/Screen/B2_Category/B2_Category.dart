import 'package:event_country/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Germany/germany.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Netherland/netherland.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/UnitedState/unitedStates.dart';
import 'package:flutter/material.dart';

import 'Category_Place/Brazil/brazil.dart';
import 'Category_Place/Paris/france.dart';

import 'package:event_country/utils/widgets/searchEvent.dart' as SearchEventWidget;
import 'package:event_country/utils/lang/lang.dart' as Lang;

final lang = Lang.Lang();

class Category extends StatefulWidget {
  String userId;
  Category({this.userId});

  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    /// Component appbar
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

    return Scaffold(
      backgroundColor: Colors.white,

      /// Calling variable appbar
      appBar: _appbar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new germany(
                            userId: widget.userId,
                            nameAppbar: "Germany",
                          )));
                },
                child: itemCard(
                    image: "assets/image/category_country/country2.png",
                    title: "Germany")),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new brazil(
                            userId: widget.userId,
                          )));
                },
                child: itemCard(
                  image: "assets/image/category_country/country3.png",
                  title: "Brazil",
                )),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new france(
                            userId: widget.userId,
                          )));
                },
                child: itemCard(
                  image: "assets/image/category_country/country4.png",
                  title: "France",
                )),
            //   itemCard(image: "assets/image/category_country/country5.png",title: "Paris",),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new netherland(
                            userId: widget.userId,
                          )));
                },
                child: itemCard(
                  image: "assets/image/category_country/country1.png",
                  title: "Netherlands",
                )),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new unitedStates(
                            userId: widget.userId,
                          )));
                },
                child: itemCard(
                  image: "assets/image/category_country/country6.png",
                  title: "United State",
                )),
          ],
        ),
      ),
    );
  }
}

///
/// Create item card
///
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
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
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
