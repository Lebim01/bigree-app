import 'dart:async';
import 'package:flutter/material.dart';

import 'package:event_country/utils/widgets/appbar.dart' as AppBarWidget;
import 'package:event_country/utils/widgets/events.dart' as EventWidget;
import 'package:event_country/utils/lang/lang.dart' as Lang;

final lang = Lang.Lang();

class allPopularEvents extends StatefulWidget {
  String userId;
  allPopularEvents({Key key, this.userId}) : super(key: key);

  @override
  _allPopularEventsState createState() => _allPopularEventsState();
}

class _allPopularEventsState extends State<allPopularEvents> {
  @override

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
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

  Widget build(BuildContext context) {
    return EventWidget.AllEventList(appBar: AppBarWidget.appBarWithButtonBackAndSearch(context));
  }
}