import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'repository.dart';

class AppThemeButton extends StatelessWidget {
  const AppThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeRepo = context.read<ThemeRepository>();
    final isDarkTheme = themeRepo.isDarkMode;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: IconButton(
        key: ValueKey(isDarkTheme),
        onPressed: () => themeRepo.saveTheme(!isDarkTheme),
        icon: isDarkTheme ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
      ),
    );
  }
}
