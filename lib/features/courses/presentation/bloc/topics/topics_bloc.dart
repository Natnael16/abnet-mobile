import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/topics_datasource.dart';
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

//