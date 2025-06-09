import 'package:flutter/material.dart';

import '../../features/features.dart';

class AppRickMortyBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  const AppRickMortyBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(centerTitle: true, title: title, actions: [AppThemeButton()]);
  }
}
