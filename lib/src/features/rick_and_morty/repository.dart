import 'package:graphql_flutter/graphql_flutter.dart';

import 'entity.dart';

abstract class RickAndMortyRepository {
  static const boxKey = 'rickAndMortyBox';
  static const endPoint = 'https://rickandmortyapi.com/graphql';

  Future<List<Character>> fetch();
}

class RickAndMortyRepositoryImpl implements RickAndMortyRepository {
  final GraphQLClient _graphQLClient;

  RickAndMortyRepositoryImpl({required GraphQLClient graphQLClient})
    : _graphQLClient = graphQLClient;

  @override
  Future<List<Character>> fetch() async {
    final response = await _graphQLClient.query(
      QueryOptions(
        document: gql(r'''
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
          '''),
      ),
    );
    final results = List.castFrom(response.data?['characters']['results']);
    return results.map((e) => Character.fromJson(e)).toList();
  }
}
