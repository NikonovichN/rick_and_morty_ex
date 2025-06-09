import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class RickAndMortyRepository {
  static const boxKey = 'rickAndMortyBox';
  static const endPoint = 'https://rickandmortyapi.com/graphql';

  Future<dynamic> fetch();
}

class RickAndMortyRepositoryImpl implements RickAndMortyRepository {
  final GraphQLClient _graphQLClient;

  RickAndMortyRepositoryImpl({required GraphQLClient graphQLClient})
    : _graphQLClient = graphQLClient;

  @override
  Future<dynamic> fetch() async {
    final qcResponse = await _graphQLClient.query(
      QueryOptions(
        document: gql(r'''
            query {
              characters(page: 2, filter: { name: "rick" }) {
                info {
                  count
                }
                results {
                  name
                }
              }
              location(id: 1) {
                id
              }
              episodesByIds(ids: [1, 2]) {
                id
              }
            }
          '''),
      ),
    );
    print('');
  }
}
