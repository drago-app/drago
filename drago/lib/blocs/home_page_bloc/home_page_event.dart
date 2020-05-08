import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserAuthenticated extends HomePageEvent {
  @override
  List<Object> get props => null;
}
