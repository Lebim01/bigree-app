import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_country/Library/bubbleTabCustom/bubbleTab.dart';
import 'package:event_country/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Paris/category/allFrance.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Paris/category/artFrance.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Paris/category/musicFrance.dart';
import 'package:event_country/Screen/B2_Category/Category_Place/Paris/category/sportFrance.dart';
import 'package:event_country/Screen/B2_Category/Page_Transformer_Card/page_transformer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class france extends StatefulWidget {
  String userId;
  france({this.userId});

  _franceState createState() => _franceState();
}

class _franceState extends State<france> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 4,
                      child: new Scaffold(
                        backgroundColor: Colors.white,
                        appBar: PreferredSize(
                          preferredSize:
                              Size.fromHeight(40.0), // here the desired height
                          child: new AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              title: new TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                unselectedLabelColor: Colors.black12,
                                labelColor: Colors.white,
                                labelStyle: TextStyle(fontSize: 19.0),
                                indicator: new BubbleTabIndicator(
                                  indicatorHeight: 36.0,
                                  indicatorColor: Color(0xFF928CEF),
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                tabs: <Widget>[
                                  new Tab(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                        fontSize: 11.2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Sport",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Art",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Music",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        body: new TabBarView(
                          children: [
                            allFrance(
                              idUser: widget.userId,
                            ),
                            sportFrance(
                              idUser: widget.userId,
                            ),
                            artFrance(
                              idUser: widget.userId,
                            ),
                            musicFrance(
                              idUser: widget.userId,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear)),
                Text(
                  "France",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.w800,
                      fontSize: 27.0,
                      letterSpacing: 1.5,
                      color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new searchPage(
                                  idUser: widget.userId,
                                )));
                      },
                      child: Icon(
                        Icons.search,
                        size: 28.0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
