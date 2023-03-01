import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../user_service.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => false;
}

class AppUninitialized extends AppState {}

class AppInitializing extends AppState {}

class AppInitializedWithAuthUser extends AppState {
  final AuthUser user;

  AppInitializedWithAuthUser({required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class AppInitializedWithoutAuthUser extends AppState {
  final AuthUser user;

  AppInitializedWithoutAuthUser({required this.user});

  @override
  List<Object> get props => [user];
}
