import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/courses_datasource.dart';
import '../../../data/models/course.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<GetCoursesEvent>(
        (GetCoursesEvent event, Emitter<CourseState> emit) async {
      emit(CourseLoading());
      try {
        List<Course> courses = await getCourses();

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
