import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/reddit_service.dart';
import '../../user_service.dart';
import './app.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final RedditService reddit;
  final UserService userService;
  List<Object> get props => [];

  AppBloc({required this.reddit, required this.userService})
      : super(AppUninitialized());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is UserTappedLogin) {
      yield* _mapUserTappedLoginToState();
    } else if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  Stream<AppState> _mapUserTappedLoginToState() async* {
    final AuthUser user = await userService.logIn();

    yield AppInitializedWithAuthUser(user: user);
  }

  Stream<AppState> _mapAppStartedToState() async* {
    yield AppInitializing();

    final user = await userService.loggedInUser();
    if (user is UnAuthUser) {
      yield AppInitializedWithoutAuthUser(
          user: UnAuthUser(name: "", token: ""));
    } else {
      yield AppInitializedWithAuthUser(user: user);
    }
  }
}
