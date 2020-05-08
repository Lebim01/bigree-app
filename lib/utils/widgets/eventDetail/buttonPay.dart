import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:event_country/graphql.dart' as myGraphql;
import 'package:event_country/utils/lang/lang.dart' as Lang;

String _mutationAsistEvent = """
  mutation {
    asistEvent(idEvent: \$idEvent){
      id
      createdAt
    }
  }
""";

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

  void _setLoading(bool state) {
    setState(() {
      loading = state;
    }); 
  }

  _buttonPay(this.idEvent, this.joined, this.loading, this.exception);

  void addData() {
    Graphql.QueryOptions _queryOptions() {
      return Graphql.QueryOptions(
        documentNode: Graphql.gql(_mutationAsistEvent),
        variables: <String, dynamic>{
          'idEvent': this.idEvent,
        },
      );
    }

    List response(Graphql.QueryResult queryResult) {
      if (queryResult.hasException) {
        throw Exception();
      }

      int idAsistEvent = queryResult.data['id'].toInteger();
      if(idAsistEvent > 0){

      }else{

      }
    }

    myGraphql
      .getGraphQLClient()
      .query(_queryOptions())
      .then(response);
  }

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.all(Radius.circular(40.0))
          ),
          child: Center(
            child: Text(
              this.loading 
                ? 'Cargando' 
                : this.exception != ''
                  ? this.exception
                  : this.joined
                    ? 'Unido'
                    : 'Unirse',
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