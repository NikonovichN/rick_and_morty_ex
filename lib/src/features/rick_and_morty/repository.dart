import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_ex/src/common/common.dart';

import 'entity.dart';

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
  static final _document = gql(r'''
           query {
              characters(page: 1) {
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
    final originalOptions = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: _document,
      onError: (e) {
        error(e.toString());
      },
    );
    _lastResult = page <= 1
        ? await _graphQLClient.query(originalOptions)
        : await _graphQLClient.fetchMore(
            FetchMoreOptions(
              variables: {'page': page},
              document: _document,
              updateQuery: (prev, next) => {...prev ?? {}, ...next ?? {}},
            ),
            originalOptions: originalOptions,
            previousResult: _lastResult,
          );

    final results = List.castFrom(_lastResult.data?['characters']['results']);
    return results.map((e) => Character.fromJson(e)).toList();
  }
}
