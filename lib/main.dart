import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/features/features.dart';
import 'src/rick_and_morty_app.dart';
import 'src/common/common.dart';

void main() {
  final logger = AppLoggerInst();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();

      final themeRepository = ThemeRepositoryImpl(box: await Hive.openBox(ThemeRepository.boxKey));

      final rickAndMortyBox = await Hive.openBox<Map<dynamic, dynamic>>(
        RickAndMortyRepository.boxKey,
      );
      final rickAndMortyRepositoryProvider = RickAndMortyRepositoryImpl(
        graphQLClient: GraphQLClient(
          cache: GraphQLCache(store: HiveStore(rickAndMortyBox)),
          link: HttpLink(RickAndMortyRepository.endPoint),
        ),
      );

      final favoritesRepository = FavoritesRepositoryImpl(
        box: await Hive.openBox<List<dynamic>>(FavoritesRepository.boxKey),
      );
      final favoritesController = FavoritesControllerImpl(repository: favoritesRepository);

      return runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeRepository>.value(value: themeRepository),
            Provider<RickAndMortyRepository>.value(value: rickAndMortyRepositoryProvider),
            Provider<FavoritesRepository>.value(value: favoritesRepository),
            Provider<FavoritesController>.value(value: favoritesController),
          ],
          child: RickAndMorty(),
        ),
      );
    },
    (error, stackTrace) {
      logger.error(error.toString());
    },
  );
}
