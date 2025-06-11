import 'package:graphql_flutter/graphql_flutter.dart';

import 'entity.dart';
import '../../common/common.dart';

abstract class RickAndMortyRepository {
  static const boxKey = 'rickAndMortyBox';
  static const endPoint = 'https://rickandmortyapi.com/graphql';

  Future<List<Character>> fetch({required int page});
}

class RickAndMortyRepositoryImpl with AppLogger implements RickAndMortyRepository {
  final GraphQLClient _graphQLClient;

  RickAndMortyRepositoryImpl({required GraphQLClient graphQLClient})
    : _graphQLClient = graphQLClient;

  late QueryResult<Object?> _lastResult;
  getDocument(int page) => gql('''
           query {
              characters(page: $page) {
                results {
                  id
                  name
                  image
                  location {
                    id
                    name
                  }
                  status
                  type
                  gender
                }
              }
            }
          ''');

  @override
  Future<List<Character>> fetch({required int page}) async {
    final document = getDocument(page);
    final originalOptions = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: document,
      onError: (e) {
        error(e.toString());
      },
    );
    _lastResult = page <= 1
        ? await _graphQLClient.query(originalOptions)
        : await _graphQLClient.fetchMore(
            FetchMoreOptions(document: document, updateQuery: (prev, next) => {...next ?? {}}),
            originalOptions: originalOptions,
            previousResult: _lastResult,
          );

    final results = List.castFrom(_lastResult.data?['characters']['results']);
    return results.map((e) => Character.fromJson(e)).toList();
  }
}
