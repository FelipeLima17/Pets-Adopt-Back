import 'dart:ffi';

class Pet {
  final String id;
  final String name;
  final int age;
  final String color;
  final List<String> images;

  Pet(
      {required this.id,
      required this.name,
      required this.age,
      required this.color,
      required this.images});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'],
      name: json['name'],
      age: int.tryParse(json['age'].toString()) ?? 0,
      color: json['color'],
      images: List<String>.from(json['images']),
    );
  }
}
