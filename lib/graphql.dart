//Provide a Base URL
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  uri: 'http://datatecblocks.xyz:4004/graphql',
);

//Provide authentication, this will go as a Header in Request
final AuthLink authLink = AuthLink(
  getToken: () async {
    return 'Bearer ';
  }
);

final Link link = authLink.concat(httpLink);

GraphQLClient _client;

// Create a common client for further requests
GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: link,
    cache: InMemoryCache(),
  );

  return _client;
}