import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../main.dart';
import '../../../data/models/teacher.dart';

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  TeachersBloc() : super(TeachersInitial()) {
    on<GetTeachersEvent>(
        (GetTeachersEvent event, Emitter<TeachersState> emit) async {
      emit(TeachersLoading());
      List<Teacher> teachers =
          await getCourseTeachers(event.courseId, event.query);
      if (teachers.isEmpty) {
        emit(const TeachersFailure(errorMessage: 'No Teachers found.'));
        return;
      }
      emit(TeachersSuccess(teachers: teachers));
    });
  }
}

Future<List<Teacher>> getCourseTeachers(int courseId, String? query) async {
  final response = await supabase.from('teacher_course').select('''
          id,
          teacher_id,
          course_id,
          teacher (
            id,
            created_at,
            life_story,
            schools_attended,
            name
          )
        ''').eq('course_id', courseId);

  if (response.isEmpty) {
    return [];
  }
  List<Teacher> teachers = [];
  for (var teach in response){
    if (query == null || teach['teacher']['name'].contains(query)) {
      teachers.add(Teacher.fromJson(teach['teacher']));
    }
  }
  return teachers;
}
