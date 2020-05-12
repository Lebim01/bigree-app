import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef GetHeaders = Future<Map<String, String>> Function();

class EventOptions {
  bool own = false;
  bool popular = false;
  String search = "";

  EventOptions({
    this.search, 
    this.own, 
    this.popular
  });

  toString(){
    List<String> options = [];

    if(search != '' && search != null) options.add('search: "${this.search}"');
    if(own != null) options.add('own: ${this.own}');
    if(popular != null) options.add('popular: ${this.popular}');

    return options.length > 1 ? "(" + options.join(',') + ")" : "";
  }
}

class JWTAuthLink extends Link {
  JWTAuthLink({ this.getHeaders }) : super(
    request: (Operation operation, [NextLink forward]) {
      StreamController<FetchResult> controller;
      
      Future<void> onListen() async {
        try {
          final Map<String, String> headers = await getHeaders();
          operation.setContext(<String, Map<String, String>>{
            'headers': headers
          });
        } catch (error) {
          controller.addError(error);
        }
        
        await controller.addStream(forward(operation));
        await controller.close();
      }

      controller = StreamController<FetchResult>(onListen: onListen);

      return controller.stream;
    },
  );

  GetHeaders getHeaders;
}

HttpLink httpLink = HttpLink(
  uri: 'http://datatecblocks.xyz:4004/graphql'
);

JWTAuthLink authLink = JWTAuthLink(
  getHeaders: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    return {
      'Authorization': 'Bearer $token'
    };
  }
);

Link link = authLink.concat(httpLink);

GraphQLClient _client;

// Create a common client for further requests
GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: link,
    cache: InMemoryCache(),
  );

  return _client;
}