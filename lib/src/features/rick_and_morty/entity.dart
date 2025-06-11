import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final String id;
  final String name;
  final String image;
  final String status;
  final String gender;
  final Location location;

  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,

    required this.gender,
    required this.location,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'status': status,
    'gender': gender,
    'location': location.toMap(),
  };

  static Character fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      gender: json['gender'] ?? '',
      location: Location.fromJson(Map<String, dynamic>.from(json['location'] as Map)),
    );
  }

  @override
  List<Object?> get props => [id, name, image, status, gender, location];
}

class Location extends Equatable {
  final String id;
  final String name;
  const Location({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  static Location fromJson(Map<String, dynamic> json) =>
      Location(id: json['id'] ?? '', name: json['name'] ?? '');

  @override
  List<Object?> get props => [id, name];
}
