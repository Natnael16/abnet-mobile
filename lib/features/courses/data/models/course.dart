import 'package:equatable/equatable.dart';

class Course extends Equatable{
  final int id;
  final String title;
  final String? description;
  final String createdAt;

  const Course({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Course(title: $title, id: $id, description: $description)';
  }

  // Factory method to create an instance from a map (for JSON parsing)
  factory Course.fromJson(dynamic json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }

  // Method to convert an instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }
  
  @override
  List<Object?> get props => [id,title,description,createdAt];
}
