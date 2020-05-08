import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_country/utils/lang/lang.dart' as Lang;
import 'package:event_country/utils/widgets/sliver.dart' as sliver;

final _lang = Lang.Lang();


class newsHeaderListDetail extends StatefulWidget {
  final String title,
      userId,
      category,
      imageUrl,
      desc,
      price,
      time,
      date,
      place,
      id,
      desc2,
      desc3;
  final index;

  newsHeaderListDetail(
      {this.id,
      this.category,
      this.desc,
      this.price,
      this.imageUrl,
      this.index,
      this.time,
      this.date,
      this.place,
      this.title,
      this.userId,
      this.desc2,
      this.desc3});

  _newsListDetailState createState() => _newsListDetailState();
}

class ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, left: 25.0, right: 30.0),
      child: Divider(
        color: Colors.black12,
        height: 2.0,
      ),
    );
  }
}

class ListItem extends StatelessWidget {

  String title = '';
  String subtitle = '';
  Widget icon_empty =  Icon(
    Icons.title,
    color: Colors.transparent,
  );
  Widget icon;

  ListItem({
    @required this.title,
    this.subtitle,
    this.icon
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: Row(
        children: <Widget>[
          this.icon == null ? this.icon_empty : this.icon,
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: "Popins"),
                ),
                Text(
                  this.subtitle,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListSimpleItem extends StatelessWidget {

  String text;

  ListSimpleItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
      child: Text(
        this.text,
        style: TextStyle(
            fontFamily: "Popins",
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class BubblePeopleEvent extends StatelessWidget {

  String idEvent;

  BubblePeopleEvent(
    this.idEvent
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("JoinEvent")
            .document("user")
            .collection(this.idEvent)
            .snapshots(),
        builder: (BuildContext ctx,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return new joinEvent(
                list: snapshot.data.documents);
          }
        },
      )
    );
  }
}

class ButtonPay extends StatelessWidget {

  String idEvent;
  String userId;

  ButtonPay(this.idEvent, this.userId);

  @override
  Widget build(BuildContext context) {
    String _join = _lang.join;

    void addData() {
      Firestore.instance.runTransaction((Transaction transaction) async {
        Firestore.instance
          .collection('users')
          .document(this.userId)
          .get()
          .then((user) => {
            
          });
        Firestore.instance
            .collection("JoinEvent")
            .document("user")
            .collection(this.idEvent)
            .document(this.userId)
            .setData({
              "npm": this.userId,
            });
      });
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () async {
          addData();
        },
        child: Container(
          height: 50.0,
          width: 180.0,
          decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius:
                  BorderRadius.all(Radius.circular(40.0))),
          child: Center(
            child: Text(
              _join,
              style: TextStyle(
                  fontFamily: "Popins",
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}

class _newsListDetailState extends State<newsHeaderListDetail> {
  String _nama, _npm, _photoProfile;
  String _join = _lang.join;

  void _getData() {
    StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading");
        } else {
          var userDocument = snapshot.data;
          _nama = userDocument["name"];
          _npm = userDocument["npm"];
          _photoProfile = userDocument["photoProfile"];

          setState(() {
            var userDocument = snapshot.data;
            _nama = userDocument["name"];
            _npm = userDocument["npm"];
            _photoProfile = userDocument["photoProfile"];
          });
        }

        var userDocument = snapshot.data;
        return Stack(
          children: <Widget>[Text(userDocument["name"])],
        );
      },
    );
  }

  _checkFirst() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString(widget.title) == null) {
      setState(() {
        _join = _lang.join;
      });
    } else {
      setState(() {
        _join = _lang.joined;
      });
    }
  }

  _check() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.title, "1");
  }

  @override
  void initState() {
    _checkFirst();
    _getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: sliver.MySliverAppBar(
                      expandedHeight: _height - 40.0,
                      img: widget.imageUrl,
                      title: widget.title,
                      id: int.parse(widget.id)
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .document(widget.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return new Text("Loading");
                          } else {
                            var userDocument = snapshot.data;
                            _nama = userDocument["name"];
                            _photoProfile = userDocument["photoProfile"];
                          }

                          var userDocument = snapshot.data;
                          return Container();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 20.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              fontFamily: "Popins"),
                        ),
                      ),
                      ListItem(
                        title: widget.date,
                        subtitle: widget.time,
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.black26,
                        )
                      ),
                      ListDivider(),
                      ListItem(
                        title: _lang.location, 
                        subtitle: widget.place,
                        icon: Icon(
                          Icons.place,
                          color: Colors.black26
                        )
                      ),
                      ListDivider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.payment,
                              color: Colors.black26,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                widget.price,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: "Popins"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListDivider(),
                      BubblePeopleEvent(widget.id),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        height: 20.0,
                        width: double.infinity,
                        color: Colors.black12.withOpacity(0.04),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 20.0),
                        child: Text(
                          _lang.about,
                          style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: "Popins"),
                        ),
                      ),
                      ListSimpleItem(widget.desc),
                      ListSimpleItem(widget.desc2),
                      ListSimpleItem(widget.desc3),
                      SizedBox(
                        height: 100.0,
                      )
                    ])),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70.0,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        widget.price,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19.0,
                            fontFamily: "Popins"),
                      ),
                    ),
                    ButtonPay(widget.id, widget.userId)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class joinEvent extends StatelessWidget {
  joinEvent({this.list});
  final List<DocumentSnapshot> list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              height: 35.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list.length > 3 ? 3 : list.length,
                itemBuilder: (context, i) {
                  String _title = list[i].data['nama'].toString();
                  String _uid = list[i].data['uid'].toString();
                  String _img = list[i].data['photoProfile'].toString();

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: NetworkImage(_img),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, left: 135.0),
          child: Text(
            list.length.toString() + " People Join",
            style: TextStyle(fontFamily: "Popins"),
          ),
        )
      ],
    );
  }
}