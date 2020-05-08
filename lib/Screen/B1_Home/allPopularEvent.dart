import 'package:flutter/material.dart';
import 'package:event_country/utils/widgets/appbar.dart' as AppBarWidget;
import 'package:event_country/utils/widgets/events.dart' as EventWidget;
import 'package:event_country/utils/lang/lang.dart' as Lang;

final lang = Lang.Lang();

class allPopularEvents extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return EventWidget.AllEventListScreen(appBar: AppBarWidget.appBarWithButtonBackAndSearch(context));
  }
}