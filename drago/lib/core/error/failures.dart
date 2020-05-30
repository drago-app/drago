import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);
  @override
  List<Object> get props => [message];
}

class SomeFailure extends Failure {
  SomeFailure({message}) : super(message);
}

class NotAuthorizedFailure extends Failure {
  NotAuthorizedFailure({message}) : super(message);
}
