import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/dialog/dialog_service.dart';
import 'package:drago/features/user/usecases.dart';
import 'package:meta/meta.dart';
import './home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetUsersModerations getUsersModerations;
  final GetUsersSubscriptions getUsersSubscriptions;
  final GetDefaultSubreddits getDefaultSubreddits;
  final DialogService dialogService;

  HomePageBloc(
      {@required this.getUsersModerations,
      @required this.getUsersSubscriptions,
      @required this.getDefaultSubreddits,
      @required this.dialogService})
      : super(HomePageInitial());

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is UserAuthenticated) {
      yield* _mapUserAuthenticatedToState();
    }
    if (event is UserNotAuthenticated) {
      yield* _mapUserNotAuthenticatedToState();
    }
  }

  Stream<HomePageState> _mapUserNotAuthenticatedToState() async* {
    yield HomePageLoading();

    final failureOrDefaults = await getDefaultSubreddits(NoParams());
    yield failureOrDefaults.fold(
        ((failure) => HomePageError(failure.message)),
        (defaults) => (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: defaults)
            : HomePageLoaded(subscriptions: defaults, moderatedSubs: []));
  }

  Stream<HomePageState> _mapUserAuthenticatedToState() async* {
    yield HomePageLoading();

    final failureOrSubs = await getUsersSubscriptions(NoParams());
    yield failureOrSubs.fold(
        ((failure) => HomePageError(failure.message)),
        (subs) => (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: subs)
            : HomePageLoaded(subscriptions: subs, moderatedSubs: []));

    final failureOrMods = await getUsersSubscriptions(NoParams());
    yield failureOrMods.fold(
        ((failure) => HomePageError(failure.message)),
        (mods) => (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: mods)
            : HomePageLoaded(subscriptions: [], moderatedSubs: mods));
  }
}
