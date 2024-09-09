class Media {
  final int id;
  final String createdAt;
  final String title;
  final List<String> type;
  final String? description;
  final int? teacherId;
  final int topicId;
  final String? documentUrl;
  final String? videoUrl;
  final String? audioUrl;

  Media({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.type,
    this.description,
    this.teacherId,
    required this.topicId,
    this.documentUrl,
    this.videoUrl,
    this.audioUrl,
  });

  // From JSON
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      createdAt: json['created_at'],
      title: json['title'],
      type: List<String>.from(json['type']),
      description: json['description'],
      teacherId: json['teacher_id'],
      topicId: json['topic_id'],
      documentUrl: json['document_url'],
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'title': title,
      'type': type,
      'description': description,
      'teacher_id': teacherId,
      'topic_id': topicId,
      'document_url': documentUrl,
      'video_url': videoUrl,
      'audio_url': audioUrl,
    };
  }
}
