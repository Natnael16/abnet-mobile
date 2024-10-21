part of 'upload_bloc.dart';

class UploadEvent extends Equatable {
  const UploadEvent({
    required this.course,
    required this.teacher,
    required this.topic,
    required this.topics,
    required this.media,
    this.document,
  });

  final Course course;
  final Teacher teacher;
  final Topic topic;
  final List<Topic> topics;
  final Map? document;
  final Map media;

  @override
  List<Object?> get props => [
        course,
        teacher,
        topic,
        topics,
      ];
}
