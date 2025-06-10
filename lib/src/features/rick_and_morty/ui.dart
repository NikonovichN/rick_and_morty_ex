import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rick_and_morty_ex/src/ui_kit/organism/character_card.dart';
import 'package:rxdart/rxdart.dart';

import '../favorites/favorites.dart';
import 'repository.dart';
import 'controller.dart';

class RickAndMortyScreen extends StatefulWidget {
  const RickAndMortyScreen({super.key});

  @override
  State<RickAndMortyScreen> createState() => _RickAndMortyScreenState();
}

class _RickAndMortyScreenState extends State<RickAndMortyScreen> {
  late final RickAndMortyRepository _repositoryRickAndMorty;
  late final RickAndMortyScreenController _rickAndMortyController;
  late final FavoritesController _favoritesController;

  @override
  void initState() {
    super.initState();
    _repositoryRickAndMorty = context.read<RickAndMortyRepository>();
    _rickAndMortyController = RickAndMortyScreenControllerImpl(repository: _repositoryRickAndMorty);
    _favoritesController = context.read<FavoritesController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favoritesController.read();
      _rickAndMortyController.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CombineLatestStream.combine2(
        _rickAndMortyController.stream,
        _favoritesController.stream,
        (rickAndMortyState, favoritesState) {
          return (rickAndMortyState, favoritesState);
        },
      ),
      builder: (context, snapshot) {
        final refreshButton = _TryToRefreshButton(
          onPressed: () {
            _favoritesController.read();
            _rickAndMortyController.loadData(refresh: true);
          },
        );

        final rickAndMortyState = snapshot.data?.$1;

        if (snapshot.data == null || rickAndMortyState?.error != null) {
          return refreshButton;
        }

        rickAndMortyState!;
        final favoriteState = snapshot.data!.$2;

        if (rickAndMortyState.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: (rickAndMortyState.characters?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (rickAndMortyState.characters == null) {
              return refreshButton;
            }

            if (index == rickAndMortyState.characters!.length) {
              if (rickAndMortyState.inProcess) {
                return const Center(child: CircularProgressIndicator());
              } else {
                _rickAndMortyController.loadData();
                return const SizedBox.shrink();
              }
            }

            final character = rickAndMortyState.characters![index];

            return CharacterCard(
              value: character,
              isSelected: favoriteState.characters != null
                  ? favoriteState.characters!.contains(character)
                  : false,
            );
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
