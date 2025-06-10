import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'controller.dart';
import '../../ui_kit/ui_kit.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _favoritesController;

  @override
  void initState() {
    super.initState();
    _favoritesController = context.read<FavoritesController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favoritesController.read();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FavoritesState>(
      stream: _favoritesController.stream,
      builder: (context, snapshot) {
        final refreshButton = TryToRefreshButton(onPressed: () => _favoritesController.read());

        final favoriteState = snapshot.data;

        if (favoriteState == null || favoriteState.error != null) {
          return refreshButton;
        }

        if (favoriteState.inProcess) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: favoriteState.characters?.length,
          itemBuilder: (context, index) {
            if (favoriteState.characters == null) {
              return refreshButton;
            }

            final character = favoriteState.characters![index];

            return CharacterCard(value: character, isSelected: true);
          },
        );
      },
    );
  }
}
