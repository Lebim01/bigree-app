import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

HttpLink httpLink = HttpLink(
  uri: 'http://datatecblocks.xyz:4004/graphql',
  headers: <String, String>{
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoidmljQGFkbWluLmNvbSIsImlhdCI6MTU4ODkwNzUxNiwiZXhwIjoxNTg4OTkzOTE2fQ.Otf0BIp1wwxztX8LsQoZKd2s1sVV5zpy65wnpRCe2qA',
  }
);

AuthLink authLink = AuthLink(
  getToken: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return 'Bearer $token';
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