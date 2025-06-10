import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

import 'entity.dart';
import '../../common/common.dart';
import 'repository.dart';

class RickAndMortyScreenState extends Equatable {
  final bool isLoading;
  final bool inProcess;
  final List<Character>? characters;
  final RepositoryException? error;
  final int lastUpdate;

  const RickAndMortyScreenState({
    required this.isLoading,
    required this.inProcess,
    this.characters,
    this.error,
    this.lastUpdate = 0,
  });

  @override
  List<Object?> get props => [isLoading, inProcess, characters, error];

  int get lastUpdateGetter => DateTime.now().millisecondsSinceEpoch;

  RickAndMortyScreenState copyWith({
    required bool inProcess,
    required bool isLoading,
    List<Character>? characters,
    ValueGetter<RepositoryException>? errorGetter,
  }) {
    return RickAndMortyScreenState(
      inProcess: inProcess,
      isLoading: isLoading,
      characters: characters ?? this.characters,
      error: errorGetter != null ? errorGetter() : null,
      lastUpdate: lastUpdateGetter,
    );
  }
}

abstract class RickAndMortyScreenController {
  Future<void> loadData({bool refresh});
  Stream<RickAndMortyScreenState> get stream;
  RickAndMortyScreenState get state;
}

class RickAndMortyScreenControllerImpl with AppLogger implements RickAndMortyScreenController {
  final StreamController<RickAndMortyScreenState> _controller =
      StreamController<RickAndMortyScreenState>.broadcast();

  RickAndMortyScreenState _state = const RickAndMortyScreenState(isLoading: false, inProcess: true);

  final RickAndMortyRepository _repository;

  RickAndMortyScreenControllerImpl({required RickAndMortyRepository repository})
    : _repository = repository;

  @override
  Stream<RickAndMortyScreenState> get stream => _controller.stream;

  @override
  RickAndMortyScreenState get state => _state;

  int pageToLoad = 0;

  void emit(RickAndMortyScreenState newState) {
    _state = newState;
    _controller.add(newState);
  }

  @override
  Future<void> loadData({bool refresh = false}) async {
    if (state.isLoading) {
      return;
    }

    final stateCharactersIsEmpty = state.characters == null || state.characters?.isEmpty == true;

    emit(
      _state.copyWith(
        isLoading: stateCharactersIsEmpty || refresh,
        inProcess: !stateCharactersIsEmpty,
        errorGetter: null,
      ),
    );

    try {
      if (refresh && state.characters != null) {
        pageToLoad = 0;
        state.characters!.clear();
      }

      pageToLoad += 1;
      final charactersResponse = await _repository.fetch(page: pageToLoad);

      info(charactersResponse.toString());

      List<Character> characters = List.from(state.characters ?? []);
      characters.addAll(charactersResponse);

      emit(_state.copyWith(isLoading: false, inProcess: false, characters: characters));
    } catch (e) {
      final errorString = e.toString();

      error(errorString);
      emit(
        _state.copyWith(
          isLoading: false,
          inProcess: false,
          errorGetter: () => RepositoryException(message: errorString),
        ),
      );
    }
  }
}
