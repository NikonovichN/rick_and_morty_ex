import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_ex/src/features/rick_and_morty/repository.dart';

import 'src/features/features.dart';
import 'src/rick_and_morty_app.dart';
import 'src/common/common.dart';

void main() {
  final logger = AppLoggerInst();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();

      final themeProvider = ThemeRepositoryImpl(box: await Hive.openBox(ThemeRepository.boxKey));

      final rickAndMortyBox = await Hive.openBox<Map<dynamic, dynamic>>(
        RickAndMortyRepository.boxKey,
      );
      final rickAndMortyRepositoryProvider = RickAndMortyRepositoryImpl(
        graphQLClient: GraphQLClient(
          cache: GraphQLCache(store: HiveStore(rickAndMortyBox)),
          link: HttpLink(RickAndMortyRepository.endPoint),
        ),
      );

      return runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeRepository>.value(value: themeProvider),
            Provider<RickAndMortyRepository>.value(value: rickAndMortyRepositoryProvider),
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
