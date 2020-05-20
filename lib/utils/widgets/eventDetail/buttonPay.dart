import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:event_country/graphql.dart' as myGraphql;
import 'package:event_country/utils/lang/lang.dart' as Lang;

final _lang = Lang.Lang();

class ButtonPay extends StatefulWidget {
  int idEvent;
  bool loading = false;
  String exception = '';
  bool joined = false;
  
  ButtonPay(this.idEvent);

  _buttonPay createState() => _buttonPay(this.idEvent, this.joined, this.loading, this.exception);
}

class _buttonPay extends State<ButtonPay> {

  int idEvent;
  bool loading = false;
  String exception = '';
  bool joined = false;

  void _setLoading(bool _state) {
    setState(() {
      loading = _state;
    });
  }

  void _setException(String _exception){
    setState(() {
      exception = _exception;
    });
  }

  void _setJoined(bool _state){
    setState(() {
      joined = _state;
    });
  }

  _buttonPay(this.idEvent, this.joined, this.loading, this.exception);

  void getData() {
    _setLoading(true);

    Graphql.QueryOptions _queryOptions() {
      return Graphql.QueryOptions(
        documentNode: Graphql.gql("""
          {
            assistEvent(idEvent: $idEvent){
              id
            }
          }
        """),
      );
    }

    void response(Graphql.QueryResult queryResult){
      
    }

    myGraphql
      .getGraphQLClient()
      .query(_queryOptions())
      .then(response);
  }

  void addData() {
    _setLoading(true);

    void response(dynamic queryResult) {
      _setLoading(false);
      _setJoined(true);
    }

    Graphql.MutationOptions _mutationOptions() {
      return Graphql.MutationOptions(
        documentNode: Graphql.gql("""
          mutation {
            assistEvent(idEvent: $idEvent){
              id
            }
          }
        """),
        onCompleted: (dynamic resultData) {
          response(resultData);
        },
        update: (Graphql.Cache cache, Graphql.QueryResult result) {
          if (result.hasException) {
            _setLoading(false);
            _setException(result.exception.graphqlErrors[0].message);
          }
        },
      );
    }

    myGraphql
      .getGraphQLClient()
      .mutate(_mutationOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () async {
          if(!joined)
            addData();
        },
        child: Container(
          height: 50.0,
          width: 180.0,
          decoration: BoxDecoration(
            color: this.exception == ''
              ? Colors.deepPurpleAccent
              : Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(40.0))
          ),
          child: Center(
            child: 
              this.loading
                ? CircularProgressIndicator()
                : Text(
                  /**
                   * Texto del boton
                   */
                  this.exception != ''
                    ? this.exception
                    : this.joined
                      ? _lang.joined
                      : _lang.join,

                  style: TextStyle(
                    fontFamily: "Popins",
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                  ),
                ),
          ),
        ),
      ),
    );
  }
}