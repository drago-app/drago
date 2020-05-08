import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/models/reddit_user.dart';
import 'package:helius/reddit_service.dart';
import 'package:meta/meta.dart';
import './app.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final RedditService reddit;

  AppBloc({@required this.reddit}) : assert(reddit != null);

  @override
  get initialState => AppUnauthenticated();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is UserTappedLogin) {
      yield* _mapUserTappedLoginToState();
    } else if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  Stream<AppState> _mapUserTappedLoginToState() async* {
    final RedditUser user = await reddit.loginWithNewAccount();

    yield AppInitialized(user: user);
  }

  Stream<AppState> _mapAppStartedToState() async* {
    yield AppInitializing();

    final RedditUser user = await reddit.init();
    yield AppInitialized(user: user);
    debugPrint(user.toString());
  }
}
