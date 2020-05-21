import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserAuthenticated extends HomePageEvent {}

class UserNotAuthenticated extends HomePageEvent {}
