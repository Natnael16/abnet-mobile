part of 'course_bloc.dart';

sealed class CourseState extends Equatable {
  const CourseState();
  
  @override
  List<Object> get props => [];
}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}
final class CourseSuccess extends CourseState {
  final List<Course> courses;

  const CourseSuccess({required this.courses });

  @override
  List<Object> get props => [courses];
}
final class CourseFailure extends CourseState {
  final String errorMessage;

  const CourseFailure({required this.errorMessage });

  @override
  List<Object> get props => [errorMessage];
}
