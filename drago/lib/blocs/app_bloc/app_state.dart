import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/models/reddit_user.dart';

import '../../user_service.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppUninitialized extends AppState {}

class AppInitializing extends AppState {}

class AppInitializedWithAuthUser extends AppState {
  final AuthUser user;

  AppInitializedWithAuthUser({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class AppInitializedWithoutAuthUser extends AppState {
  // final AuthUser user;

  AppInitializedWithoutAuthUser();

  // @override
  // List<Object> get props => [user];
}
