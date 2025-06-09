import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../common/common.dart';
import 'repository.dart';

class RickAndMortyScreenData extends Equatable {
  const RickAndMortyScreenData();

  @override
  List<Object?> get props => [];
}

class RickAndMortyScreenState extends Equatable {
  final bool isLoading;
  final bool inProcess;
  final RickAndMortyScreenData? screenData;
  final RepositoryException? error;

  const RickAndMortyScreenState({
    required this.isLoading,
    required this.inProcess,
    this.screenData,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, inProcess, screenData, error];

  RickAndMortyScreenState copyWith({
    required bool inProcess,
    required bool isLoading,
    RickAndMortyScreenData? screenData,
    RepositoryException? error,
  }) {
    return RickAndMortyScreenState(
      inProcess: inProcess,
      isLoading: isLoading,
      screenData: screenData ?? this.screenData,
      error: error ?? this.error,
    );
  }
}

abstract class RickAndMortyScreenController {
  Future<void> loadData();
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

  void emit(RickAndMortyScreenState newState) {
    _state = newState;
    _controller.add(newState);
  }

  @override
  Future<void> loadData({bool refresh = false}) async {
    if (state.isLoading) {
      return;
    }

    emit(_state.copyWith(isLoading: true, inProcess: false, error: null));

    try {
      final repositoryData = await _repository.fetch();

      info(repositoryData.toString());

      emit(_state.copyWith(isLoading: false, inProcess: false));
    } catch (e) {
      final errorString = e.toString();

      error(errorString);
      emit(
        _state.copyWith(
          isLoading: false,
          inProcess: false,
          error: RepositoryException(message: errorString),
        ),
      );
    }
  }
}
