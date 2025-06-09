import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/features.dart';
import 'navigation/bottom_navigation_bar_with_scaffold.dart';
import 'ui_kit/ui_kit.dart';

class RickAndMorty extends StatelessWidget {
  const RickAndMorty({super.key});

  @override
  Widget build(BuildContext context) {
    final themeRepo = context.watch<ThemeRepository>();
    final isDarkTheme = themeRepo.isDarkMode;

    return MaterialApp(
      title: 'Rick And Morty App',
      theme: ThemeData(colorScheme: isDarkTheme ? AppDarkColorScheme() : AppLightColorScheme()),
      home: BottomNavigationBarWithScaffold(),
    );
  }
}
