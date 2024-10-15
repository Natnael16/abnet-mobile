import 'package:equatable/equatable.dart';

class Teacher extends Equatable{
  final int id;
  final String createdAt;
  final String lifeStory;
  final List<String> schoolsAttended;
  final String name;

  Teacher({
    required this.id,
    required this.createdAt,
    required this.lifeStory,
    required this.schoolsAttended,
    required this.name,
  });

  // Factory method to create an instance from a map (for JSON parsing)
  factory Teacher.fromJson(dynamic json) {
    return Teacher(
      id: json['id'],
      createdAt: json['created_at'],
      lifeStory: json['life_story'],
      schoolsAttended: List<String>.from(json['schools_attended'] ?? []),
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'Teacher(name: $name, id: $id)';
  }

  // Method to convert an instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'life_story': lifeStory,
      'schools_attended': schoolsAttended,
      'name': name,
    };
  }
  
  @override
  List<Object?> get props => [id,name,createdAt,lifeStory];
}
