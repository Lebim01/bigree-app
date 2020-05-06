import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:event_country/utils/widgets/events.dart' as EventWidget;
import 'package:event_country/utils/lang/lang.dart' as Lang;
import 'package:event_country/utils/widgets/appbar.dart' as AppBarWidget;

final lang = Lang.Lang();

///
/// Intro if user open first apps
///
class showCaseHome extends StatefulWidget {
  String userId;

  showCaseHome({this.userId});
  _showCaseHomeState createState() => _showCaseHomeState();
}

class _showCaseHomeState extends State<showCaseHome> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
          builder: (context) => Home(
                userId: widget.userId,
              )),
    );
  }
}

class Home extends StatefulWidget {
  String userId;
  Home({this.userId});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _profileShowCase = GlobalKey();
  GlobalKey _searchShowCase = GlobalKey();
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  bool _connection = true;

  ///
  /// Check connectivity
  ///
  @override
  void initState() {
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          _connection = false;
        });
      }
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState

    @override
    void dispose() {
      subscription.cancel();
      super.dispose();
    }

    super.initState();
  }

  Widget _search = Container(
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
  );

  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool showcaseVisibilityStatus = preferences.getBool("showShowcase");

      if (showcaseVisibilityStatus == null) {
        preferences.setBool("showShowcase", false).then((bool success) {
          if (success)
            print("Successfull in writing showshoexase");
          else
            print("some bloody problem occured");
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _profileShowCase,
          _searchShowCase,
        ]);
      }
    });

    return KeysToBeInherited(
      profileShowCase: _profileShowCase,
      searchShowCase: _searchShowCase,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.event,
            style: TextStyle(
                fontFamily: "Sofia",
                fontWeight: FontWeight.w800,
                fontSize: 33.0,
                letterSpacing: 1.5,
                color: Colors.black),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            photoProfile(
              userId: widget.userId,
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    child: search()
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(lang.popularEvents,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Sofia",
                              fontSize: 17.0)),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                new EventWidget.AllEventList(
                                  appBar: AppBarWidget.appBarWithButtonBackAndSearch(context)
                              )
                            )
                          );
                        },
                        child: Text(
                          lang.viewAll,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Sofia",
                            color: Colors.deepPurpleAccent)
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class photoProfile extends StatelessWidget {
  String userId;

  photoProfile({this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection('users').document(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 9.0),
              child: InkWell(
                  onTap: () {
                  },
                  child: Showcase(
                    key: KeysToBeInherited.of(context).profileShowCase,
                    description: "Photo Profile",
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          image: DecorationImage(
                              image: NetworkImage(userDocument[
                                          "photoProfile"] !=
                                      null
                                  ? userDocument["photoProfile"]
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                              fit: BoxFit.cover)),
                    ),
                  )),
            ),
          ]);
        });
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


