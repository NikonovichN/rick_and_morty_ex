import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'repository.dart';
import 'entity.dart';
import 'controller.dart';

class RickAndMortyScreen extends StatelessWidget {
  const RickAndMortyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<RickAndMortyRepository>();
    final screenController = RickAndMortyScreenControllerImpl(repository: repository);

    screenController.loadData();

    return StreamBuilder<RickAndMortyScreenState>(
      stream: screenController.stream,
      builder: (context, snapshot) {
        final refreshButton = _TryToRefreshButton(
          onPressed: () => screenController.loadData(refresh: true),
        );

        if (snapshot.data == null || snapshot.data!.error != null) {
          return refreshButton;
        }

        final state = snapshot.data!;

        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: (state.characters?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (state.characters == null) {
              return refreshButton;
            }

            if (index == state.characters!.length) {
              if (state.inProcess) {
                return const Center(child: CircularProgressIndicator());
              } else {
                screenController.loadData();
                return const SizedBox.shrink();
              }
            }

            final character = state.characters![index];

            return _CharacterCard(value: character);
          },
        );
      },
    );
  }
}

class _TryToRefreshButton extends StatelessWidget {
  static const _text = 'Try to refresh';
  final void Function()? onPressed;
  const _TryToRefreshButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(colorScheme.primary)),
        onPressed: onPressed,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: colorScheme.onPrimary),
          child: Text(_text),
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character value;
  final VoidCallback? onAddToFavorite;
  const _CharacterCard({required this.value, this.onAddToFavorite});

  static const _padding = EdgeInsets.all(20.0);
  static const _margin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
  static const _borderRadius = BorderRadius.all(Radius.circular(10.0));
  static const _emptyHeightM = SizedBox(height: 8.0);
  static const _emptyHeightS = SizedBox(height: 4.0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  Text(value.name, style: TextStyle(fontSize: 22)),
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
