part of 'topics_bloc.dart';

sealed class TopicsEvent extends Equatable {
  const TopicsEvent();

  @override
  List<Object> get props => [];
}

class GetTopicsEvent extends TopicsEvent {
  final int courseId;
  final int teacherId;
  final int? superTopicId;

  const GetTopicsEvent(
      {required this.courseId, required this.teacherId, this.superTopicId});
}

class ClearTopicsEvent extends TopicsEvent {}
