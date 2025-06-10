import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

import '../../common/common.dart';
import '../rick_and_morty/entity.dart';
import 'repository.dart';

class FavoritesState extends Equatable {
  final bool inProcess;
  final List<Character>? characters;
  final RepositoryException? error;
  final int lastUpdate;

  const FavoritesState({required this.inProcess, this.characters, this.error, this.lastUpdate = 0});

  @override
  List<Object?> get props => [inProcess, characters, error];

  int get lastUpdateGetter => DateTime.now().millisecondsSinceEpoch;

  FavoritesState copyWith({
    required bool inProcess,

    List<Character>? characters,
    ValueGetter<RepositoryException>? errorGetter,
  }) {
    return FavoritesState(
      inProcess: inProcess,
      characters: characters ?? this.characters,
      error: errorGetter != null ? errorGetter() : null,
      lastUpdate: lastUpdateGetter,
    );
  }
}

enum SortType { name, status, gender }

abstract class FavoritesController {
  void read();
  Future<void> add({required Character character});
  Future<void> remove({required String id});
  void sortBy({SortType type});
  Stream<FavoritesState> get stream;
  FavoritesState get state;
}

class FavoritesControllerImpl with AppLogger implements FavoritesController {
  final StreamController<FavoritesState> _controller = StreamController<FavoritesState>.broadcast();

  FavoritesState _state = const FavoritesState(inProcess: false);

  final FavoritesRepository _repository;

  FavoritesControllerImpl({required FavoritesRepository repository}) : _repository = repository;

  @override
  Stream<FavoritesState> get stream => _controller.stream;

  @override
  FavoritesState get state => _state;

  void emit(FavoritesState newState) {
    _state = newState;
    _controller.add(newState);
  }

  void emitErrorState(String error) {
    emit(state.copyWith(inProcess: false, errorGetter: () => RepositoryException(message: error)));
  }

  @override
  void read() {
    try {
      emit(state.copyWith(inProcess: false, characters: _repository.characters, errorGetter: null));
    } catch (e) {
      emitErrorState(e.toString());
    }
  }

  @override
  Future<void> add({required Character character}) async {
    emit(state.copyWith(inProcess: true, errorGetter: null));
    try {
      await _repository.add(character: character);
      emit(state.copyWith(inProcess: false, characters: _repository.characters));
    } catch (e) {
      emitErrorState(e.toString());
    }
  }

  @override
  Future<void> remove({required String id}) async {
    emit(state.copyWith(inProcess: true, errorGetter: null));
    try {
      await _repository.remove(id: id);
      emit(state.copyWith(inProcess: false, characters: _repository.characters));
    } catch (e) {
      emitErrorState(e.toString());
    }
  }

  @override
  void sortBy({SortType type = SortType.name}) {
    if (state.characters != null && state.characters!.isNotEmpty) {
      state.characters!.sort((a, b) {
        return switch (type) {
          SortType.name => b.name.toLowerCase().compareTo(b.name.toLowerCase()),
          SortType.gender => b.gender.toLowerCase().compareTo(b.gender.toLowerCase()),
          SortType.status => b.status.toLowerCase().compareTo(b.status.toLowerCase()),
        };
      });
      emit(state.copyWith(inProcess: false, characters: state.characters!));
    }
  }
}
