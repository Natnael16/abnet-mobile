part of 'topics_bloc.dart';

sealed class TopicsState extends Equatable {
  const TopicsState();

  @override
  List<Object> get props => [];
}

final class TopicsInitial extends TopicsState {}

final class TopicsLoading extends TopicsState {}

final class TopicsSuccess extends TopicsState {
  final List<Topic> topics;

  const TopicsSuccess({required this.topics});

  @override
  List<Object> get props => [topics];
}

final class TopicsFailure extends TopicsState {
  final String errorMessage;

  const TopicsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ClearTopicsState extends TopicsState {}
