import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../courses/data/datasource/media_datasource.dart';
import '../../../../courses/data/models/course.dart';
import '../../../../courses/data/models/teacher.dart';
import '../../../../courses/data/models/topic.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadInitial()) {
    on<UploadEvent>((event, emit) async {
      emit(UploadLoading());
      try {
        bool result = await createDocument(
            course: event.course,
            teacher: event.teacher,
            topic: event.topic,
            subTopics: event.topics,
            doc: event.document,
            media: event.media);

        if (result) {
            emit(UploadSuccess());
          return;
        }

        emit(const UploadFailure(message: "Couldn't create documents"));
      } catch (e) {
        emit(UploadFailure(message: 'Error occured $e.'));
      }
    });
  }
}
