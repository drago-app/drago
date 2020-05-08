import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class UserTappedLogin extends AppEvent {}

class AppStarted extends AppEvent {}
