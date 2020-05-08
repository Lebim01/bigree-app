import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:event_country/Screen/B1_Home/Home_Search/search_page.dart' as SearchPage;
import 'package:event_country/utils/lang/lang.dart' as Lang;

final _lang = Lang.Lang();

AppBar appBarWithButtonBackAndSearch(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0.0,
    title: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        _lang.allEvents,
        style: TextStyle(
          fontFamily: "Gotik",
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.w700
        ),
      ),
    ),
    actions: <Widget>[
      InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new SearchPage.searchPage()
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
}