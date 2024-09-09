import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/teachers_datasource.dart';
import '../../../data/models/teacher.dart';

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  TeachersBloc() : super(TeachersInitial()) {
    on<GetTeachersEvent>(
        (GetTeachersEvent event, Emitter<TeachersState> emit) async {
      emit(TeachersLoading());
      try {
        List<Teacher> teachers =
            await getCourseTeachers(event.courseId, event.query);
        if (teachers.isEmpty) {
          emit(const TeachersFailure(errorMessage: 'No Teachers found.'));
          return;
        }
        emit(TeachersSuccess(teachers: teachers));
      } catch (e) {
        emit(TeachersFailure(errorMessage: 'Error occured $e'));
      }
    });
  }
}
