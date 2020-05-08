import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:event_country/utils/lang/lang.dart' as Lang;

final _lang = Lang.Lang();

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String img, title;
  int id;

  MySliverAppBar({@required this.expandedHeight, this.img, this.title, this.id});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Colors.white,
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-tag-${id.toString()}',
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(img),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 130.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[
                        new Color(0x00FFFFFF),
                        new Color(0xFFFFFFFF),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0)),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Icon(Icons.arrow_back),
                    ))),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 250.0,
                child: Text(
                  _lang.event,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 25.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
