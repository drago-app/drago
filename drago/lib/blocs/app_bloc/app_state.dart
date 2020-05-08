import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/models/reddit_user.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppUnauthenticated extends AppState {}

class AppInitializing extends AppState {}

class AppAuthenticated extends AppState {}

class AppInitialized extends AppState {
  final RedditUser user;

  AppInitialized({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}
