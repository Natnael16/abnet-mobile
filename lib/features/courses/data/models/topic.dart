class Topic {
  final int id;
  final String createdAt;
  final String title;
  final String description;
  final int? superTopicId; // Nullable field
  final int? teacherCourseId; // Nullable field

  Topic({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    this.superTopicId,
    this.teacherCourseId,
  });

  // Factory method to create an instance from a map (for JSON parsing)
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      createdAt: json['created_at'],
      title: json['title'],
      description: json['description'],
      superTopicId: json['super_topic_id'],
      teacherCourseId: json['teacher_course_id'],
    );
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
    };
  }
}
