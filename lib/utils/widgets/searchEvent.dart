

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase.dart';
import 'package:event_country/utils/lang/lang.dart' as Lang;

final lang = Lang.Lang();

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey profileShowCase;
  final GlobalKey searchShowCase;
  final GlobalKey joinShowCase;

  KeysToBeInherited({
    this.profileShowCase,
    this.searchShowCase,
    this.joinShowCase,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(KeysToBeInherited);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class search extends StatelessWidget {
  const search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: KeysToBeInherited.of(context).searchShowCase,
      description: "Click Here To Search Events",
      child: Container(
        height: 45.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5.0,
                  spreadRadius: 0.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                lang.findEvent,
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                    fontSize: 16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}