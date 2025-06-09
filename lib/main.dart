import 'dart:async';

import 'package:flutter/material.dart';

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

      final themeProvider = ThemeRepositoryImpl(
        box: await Hive.openBox(ThemeRepository.themeHiveBoxKey),
      );

      return runApp(
        ChangeNotifierProvider<ThemeRepository>.value(
          value: themeProvider,
          child: const RickAndMorty(),
        ),
      );
    },
    (error, stackTrace) {
      logger.error(error.toString());
    },
  );
}
