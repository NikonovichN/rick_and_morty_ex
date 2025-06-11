import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../features/favorites/controller.dart';
import '../../features/rick_and_morty/entity.dart';

class CharacterCard extends StatelessWidget {
  final Character value;
  final bool isSelected;

  const CharacterCard({super.key, required this.value, required this.isSelected});

  static const _padding = EdgeInsets.all(20.0);
  static const _margin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
  static const _borderRadius = BorderRadius.all(Radius.circular(10.0));
  static const _emptyHeightM = SizedBox(height: 8.0);
  static const _emptyHeightS = SizedBox(height: 4.0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final favoritesController = context.read<FavoritesController>();

    return Container(
      padding: _padding,
      margin: _margin,
      decoration: BoxDecoration(color: colorScheme.primary, borderRadius: _borderRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: _borderRadius,
            child: CachedNetworkImage(
              imageUrl: value.image,
              progressIndicatorBuilder: (context, url, progress) =>
                  const Center(child: CircularProgressIndicator()),
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.0),
          DefaultTextStyle.merge(
            style: TextStyle(color: colorScheme.onPrimary),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(value.name, style: TextStyle(fontSize: 22))),
                      SizedBox(width: 12.0),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: IconButton(
                          key: ValueKey(isSelected),
                          iconSize: 24.0,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
                          ),
                          onPressed: isSelected
                              ? () => favoritesController.remove(id: value.id)
                              : () => favoritesController.add(character: value),
                          icon: Icon(isSelected ? Icons.favorite : Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                  _emptyHeightM,
                  Text(value.gender, style: TextStyle(fontSize: 14)),
                  _emptyHeightS,
                  Text(value.status, style: TextStyle(fontSize: 14)),
                  _emptyHeightS,
                  Text(value.location.name, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
