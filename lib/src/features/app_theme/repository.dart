import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

abstract class ThemeRepository with ChangeNotifier {
  static const boxKey = 'themeBox';
  Future<void> saveTheme(bool isDarkMode);
  bool get isDarkMode;
}

class ThemeRepositoryImpl with ChangeNotifier implements ThemeRepository {
  final Box _box;

  ThemeRepositoryImpl({required Box box}) : _box = box;

  @override
  bool get isDarkMode => (_box.get(ThemeRepository.boxKey, defaultValue: true) as bool);

  @override
  Future<void> saveTheme(bool isDarkMode) async {
    _box.put(ThemeRepository.boxKey, isDarkMode);
    notifyListeners();
  }
}
