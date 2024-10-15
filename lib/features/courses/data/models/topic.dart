import 'package:equatable/equatable.dart';

import 'media.dart';

class Topic extends Equatable {
  final int id;
  final String createdAt;
  final String title;
  final String description;
  final int? superTopicId; // Nullable field
  final int? teacherCourseId; // Nullable field
  bool isTopicFinal;
  Media? media;

  Topic(
      {required this.id,
      required this.createdAt,
      required this.title,
      required this.description,
      this.superTopicId,
      this.teacherCourseId,
      this.isTopicFinal = false,
      this.media});

  // Factory method to create an instance from a map (for JSON parsing)
  factory Topic.fromJson(dynamic json) {
    return Topic(
        id: json['id'],
        createdAt: json['created_at'],
        title: json['title'],
        description: json['description'] ?? '',
        superTopicId: json['super_topic_id'],
        teacherCourseId: json['teacher_course_id'],
        isTopicFinal: json['is_topic_final'] ?? false,
        media: json['media'] != null ? Media.fromJson(json['media']): null);
  }

  @override
  String toString() {
    return 'Topic(title: $title, id: $id, media: $media, superTopicId: $superTopicId)';
  }
  // Method to convert an instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'title': title,
      'description': description,
      'super_topic_id': superTopicId,
      'teacher_course_id': teacherCourseId,
      'is_topic_final': isTopicFinal,
      'media': media?.toJson(),
    };
  }
  
  @override
  List<Object?> get props => [id,title,description,superTopicId,teacherCourseId,isTopicFinal];
}
