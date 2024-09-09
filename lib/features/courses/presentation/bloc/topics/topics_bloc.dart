import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../main.dart';
import '../../../data/models/media.dart';
import '../../../data/models/topic.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  TopicsBloc() : super(TopicsInitial()) {
    on<GetTopicsEvent>((event, emit) async {
      emit(TopicsLoading());
      try {
        print(
            "payloads : ${event.courseId} - ${event.superTopicId} - ${event.teacherId}");
        List<Topic> topics = await getTopics(
            event.courseId, event.teacherId, event.superTopicId);
        if (topics.isEmpty) {
          emit(const TopicsFailure(errorMessage: 'No topics found.'));
          return;
        }
        emit(TopicsSuccess(topics: topics));
      } catch (e) {
        emit(TopicsFailure(errorMessage: 'Some Error occured $e'));
      }
    });
    on<ClearTopicsEvent>((event, emit) {
      emit(ClearTopicsState());
    });
  }
}

/// api calls from supabase

Future<List<Topic>> getTopics(int courseId, int teacherId, int? topicId) async {
  List<dynamic> response;
  if (topicId == null) {
    List<dynamic> teacherCourse = await supabase
        .from("teacher_course")
        .select("id")
        .eq("course_id", courseId)
        .eq("teacher_id", teacherId)
        .limit(1);
    response = await supabase
        .from('topic')
        .select('*')
        .eq('teacher_course_id', teacherCourse.first['id']);
  } else {
    response =
        await supabase.from('topic').select('*').eq('super_topic_id', topicId);
  }
  List<Topic> topics = [];
  for (var t in response) {
    var topic = Topic.fromJson(t);
    Media? media = await doesTopicHasMedia(topic.id);
    topic.isTopicFinal = media != null;
    topic.media = media;
    topics.add(topic);
  }
  return topics;
}

Future<Media?> doesTopicHasMedia(int topicId) async {
  final response =
      await supabase.from('media').select("*").eq('topic_id', topicId);
  if (response.isEmpty) {
    return null;
  }
  Media media = Media.fromJson(response.first);
  return media;
}
