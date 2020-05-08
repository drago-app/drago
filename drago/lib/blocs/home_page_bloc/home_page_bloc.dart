import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:helius/core/usecases/usecase.dart';
import 'package:helius/features/user/usecases.dart';
import 'package:meta/meta.dart';
import './home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetUsersModerations getUsersModerations;
  final GetUsersSubscriptions getUsersSubscriptions;

  HomePageBloc(
      {@required this.getUsersModerations,
      @required this.getUsersSubscriptions});

  @override
  get initialState => HomePageInitial();

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is UserAuthenticated) {
      yield* _mapUserAuthenticatedToState();
    }
  }

  Stream<HomePageState> _mapUserAuthenticatedToState() async* {
    yield HomePageLoading();

    final failureOrSubs = await getUsersSubscriptions(NoParams());
    yield failureOrSubs.fold(
        ((failure) => HomePageError()),
        (subs) => (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: subs)
            : HomePageLoaded(subscriptions: subs, moderatedSubs: []));

    final failureOrMods = await getUsersSubscriptions(NoParams());
    yield failureOrMods.fold(
        ((failure) => HomePageError()),
        (mods) => (state is HomePageLoaded)
            ? (state as HomePageLoaded).copyWith(subscriptions: mods)
            : HomePageLoaded(subscriptions: [], moderatedSubs: mods));
  }
}
