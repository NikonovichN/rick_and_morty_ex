import 'package:hive_flutter/hive_flutter.dart';

import '../rick_and_morty/entity.dart';

abstract class FavoritesRepository {
  static const boxKey = 'favorites';

  Future<void> add({required Character character});
  Future<void> remove({required String id});

  List<Character> get characters;
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box _box;

  FavoritesRepositoryImpl({required Box box}) : _box = box;

  @override
  List<Character> get characters {
    final repository = _box.get(FavoritesRepository.boxKey, defaultValue: []);
    if (repository.isEmpty) return [];
    final characters = repository.map(
      (c) => Character.fromJson(Map<String, dynamic>.from(c as Map)),
    );
    return List.from(characters);
  }

  @override
  Future<void> add({required Character character}) async {
    final hasValue = characters.where((c) => c.id == character.id).firstOrNull != null;
    if (!hasValue) {
      List<Character> newDataBox = List.from(characters);
      newDataBox.add(character);
      await _box.put(FavoritesRepository.boxKey, newDataBox.map((c) => c.toMap()).toList());
    }
  }

  @override
  Future<void> remove({required String id}) async {
    List newDataBox = characters..removeWhere((c) => c.id == id);
    await _box.put(FavoritesRepository.boxKey, newDataBox.map((c) => c.toMap()).toList());
  }
}
