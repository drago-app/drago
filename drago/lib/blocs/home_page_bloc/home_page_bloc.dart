import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/core/entities/subreddit.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/dialog/dialog_service.dart';
import 'package:drago/features/user/usecases.dart';
import './home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetUsersModerations getUsersModerations;
  final GetUsersSubscriptions getUsersSubscriptions;
  final GetDefaultSubreddits getDefaultSubreddits;
  final DialogService dialogService;

  HomePageBloc(
      {required this.getUsersModerations,
      required this.getUsersSubscriptions,
      required this.getDefaultSubreddits,
      required this.dialogService})
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

    yield* failureOrDefaults.fold(
      (failure) async* {
        yield HomePageError(failure.message);
      },
      (List<Subreddit> defaults) async* {
        final subs = defaults;

        yield (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: subs)
            : HomePageLoaded(subscriptions: subs, moderatedSubs: []);
      },
    );
  }

  Stream<HomePageState> _mapUserAuthenticatedToState() async* {
    yield HomePageLoading();

    final failureOrSubs = await getUsersSubscriptions(NoParams());

    yield* failureOrSubs.fold(
      (failure) async* {
        yield HomePageError(failure.message);
      },
      (List<Subreddit> subscriptions) async* {
        final subs = subscriptions;

        yield (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: subs)
            : HomePageLoaded(subscriptions: subs, moderatedSubs: []);
      },
    );

    final failureOrMods = await getUsersModerations(NoParams());

    yield* failureOrMods.fold(
      (failure) async* {
        yield HomePageError(failure.message);
      },
      (List<Subreddit> mods) async* {
        final m = mods;

        yield (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(moderatedSubs: m)
            : HomePageLoaded(subscriptions: [], moderatedSubs: m);
      },
    );
  }
}
