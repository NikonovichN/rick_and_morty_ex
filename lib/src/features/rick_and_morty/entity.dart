class Character {
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

  static Character fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      gender: json['gender'] ?? '',
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final String id;
  final String name;
  const Location({required this.id, required this.name});

  static Location fromJson(Map<String, dynamic> json) =>
      Location(id: json['id'] ?? '', name: json['name'] ?? '');
}
