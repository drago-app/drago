import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => false;
}

class AppUninitialized extends AppState {}

class AppInitializing extends AppState {}

class AppInitializedWithAuthUser extends AppState {
  final String username;

  AppInitializedWithAuthUser({required this.username});

  @override
  List<Object> get props => [username];
}

class AppInitializedWithoutAuthUser extends AppState {
  AppInitializedWithoutAuthUser();

  @override
  List<Object> get props => [];
}
