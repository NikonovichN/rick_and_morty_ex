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
    final colorScheme = Theme.of(context).colorScheme;
    final textButtonStyle = TextStyle(color: colorScheme.onSurface);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sort:'),
              TextButton(
                onPressed: () => _favoritesController.sortBy(type: SortType.name),
                child: Text('By Name', style: textButtonStyle),
              ),
              TextButton(
                onPressed: () => _favoritesController.sortBy(type: SortType.gender),
                child: Text('By Gender', style: textButtonStyle),
              ),
              TextButton(
                onPressed: () => _favoritesController.sortBy(type: SortType.status),
                child: Text('By Status', style: textButtonStyle),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<FavoritesState>(
            stream: _favoritesController.stream,
            builder: (context, snapshot) {
              final refreshButton = TryToRefreshButton(
                onPressed: () => _favoritesController.read(),
              );

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
          ),
        ),
      ],
    );
  }
}
