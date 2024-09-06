part of 'teachers_bloc.dart';

sealed class TeachersState extends Equatable {
  const TeachersState();
  
  @override
  List<Object> get props => [];
}

final class TeachersInitial extends TeachersState {}


final class TeachersLoading extends TeachersState {}

final class TeachersSuccess extends TeachersState {
  final List<Teacher> teachers;

  const TeachersSuccess({required this.teachers});

  @override
  List<Object> get props => [teachers];
}

final class TeachersFailure extends TeachersState {
  final String errorMessage;

  const TeachersFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
