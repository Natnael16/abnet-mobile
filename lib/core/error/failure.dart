import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);
}

class CacheFailure extends Failure {
  const CacheFailure(super.errorMessage);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.errorMessage);
}
