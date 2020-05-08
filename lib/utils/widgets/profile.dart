
import 'package:event_country/Screen/B1_Home/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:showcaseview/showcase.dart';

String _defaultPhoto = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png";

Widget _photoProfile(context, url){
  return Stack(
    children: <Widget>[
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
                    image: NetworkImage(url != '' ? url : _defaultPhoto),
                    fit: BoxFit.cover
                )
              ),
            ),
          )
        ),
      ),
    ]
  );
}

class photoProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql("""
          {
            profile {
              image
            }
          }
        """
        ),
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.loading) {
          return _photoProfile(context, _defaultPhoto);
        } else if(result.hasException) {
          return _photoProfile(context, _defaultPhoto);
        } else {
          dynamic profile = result.data['profile'];
          return _photoProfile(context, profile['image']);
        }
      },
    );
  }
}