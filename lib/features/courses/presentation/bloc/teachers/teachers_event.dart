part of 'teachers_bloc.dart';

sealed class TeachersEvent extends Equatable {
  const TeachersEvent();

  @override
  List<Object> get props => [];
}

class GetTeachersEvent extends TeachersEvent {
  final int courseId;
  final String? query;
  const GetTeachersEvent({this.query,required this.courseId});
}
