import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:event_country/Screen/B3_Manage_Event/Create_Event.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screen/Bottom_Nav_Bar/bottomNavBar.dart';
import 'Screen/Login/OnBoarding.dart';
import 'dart:io' show Platform;
import 'package:event_country/graphql.dart' as graphql;

/// Run first apps open
void main() {
  runApp(myApp());
}

/// Set orienttation
class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: graphql.httpLink,
      ),
    );


    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    
    return new GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: "Event Country",
        theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primaryColorLight: Colors.white,
            primaryColorBrightness: Brightness.light,
            primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        /// Move splash screen to ChoseLogin Layout
        /// Routes
        routes: <String, WidgetBuilder>{
          "login": (BuildContext context) => new SplashScreen(),
          "createEvent": (BuildContext context) => new createEvent() 
        },
      )
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  bool _connection = false;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    ///
    /// Check connectivity
    ///
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          startTime();
          _connection = false;
        });
      } else {
        setState(() {
          _connection = true;
        });
      }
    });

    if (Platform.isAndroid) {
      // Android-specific code
    } else if (Platform.isIOS) {
      startTime();
      // iOS-specific code
    }

    ///
    /// Setting Message Notification from firebase to user
    ///
    _messaging.getToken().then((token) {
      print(token);
    });

    @override
    void dispose() {
      subscription.cancel();
      super.dispose();
    }
  }

  /// Check user
  bool _checkUser = true;

  bool loggedIn = false;

  @override
  SharedPreferences prefs;

  ///
  /// Checking user is logged in or not logged in
  ///
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        print('false');
        _checkUser = false;
      } else {
        print('true');
        _checkUser = true;
      }
    });
  }

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), NavigatorPage);
  }

  /// Navigate user if already login or no
  void NavigatorPage() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) {
              if (currentUser == null)
                {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => onBoarding()));
                }
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => bottomNavBar(
                                        idUser: currentUser.uid,
                                      ))))
                      .catchError((err) => print(err));
                }
            })
        .catchError((err) => print(err));
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    ///
    /// Check connectivity
    ///
    return _connection

        ///
        /// Layout if user not connect internet
        ///
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                ),
                Container(
                  height: 270.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/noInternet.png")),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "No Connection",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Sofia",
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurpleAccent),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Text(
                    "No internet connection found. Check your connection or try again",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Sofia",
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        :

        ///
        /// Layout if user connect internet
        ///

        Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/image/cover.png",
                        ),
                        fit: BoxFit.cover)),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Event Country",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w200,
                              fontSize: 36.0,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
