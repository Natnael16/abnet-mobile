import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../main.dart';
import '../../../data/models/course.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<GetCoursesEvent>(
        (GetCoursesEvent event, Emitter<CourseState> emit) async {
      emit(CourseLoading());
      List<Course> courses = await getCourses();
      try {
        if (courses.isEmpty) {
          emit(const CourseFailure(errorMessage: 'No courses found.'));
          return;
        }
        emit(CourseSuccess(courses: courses));
      } catch (e) {
        emit(CourseFailure(errorMessage: 'Error occured $e.'));
      }
    });
  }
}

Future<List<Course>> getCourses() async {
  final response = await supabase
      .from('course')
      .select('id, created_at, title, description');

  if (response.isEmpty) {
    return [];
  }

  List<Course> courses = (response as List<dynamic>)
      .map((course) => Course.fromJson(course))
      .toList();

  return courses;
}
