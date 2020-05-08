import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class SomeFailure extends Failure {
  final String message;
  SomeFailure({this.message});
}
