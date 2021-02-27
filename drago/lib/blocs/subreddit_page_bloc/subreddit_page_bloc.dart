import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/features/subreddit/subscribe_to_subreddit.dart';
import 'package:drago/icons_enum.dart';
import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import './subreddit_page.dart';
import 'package:rxdart/rxdart.dart';

class SubredditPageBloc extends Bloc<SubredditPageEvent, SubredditPageState> {
  final String subreddit;
  final GetRedditLinks getRedditLinks;
  final ActionService actionService;
  final Map<SubmissionSortType, SubmissionSort> _sortOptions = {
    SubmissionSortType.hot: hotSubmissionSort,
    SubmissionSortType.newest: newestSubmissionSort,
    SubmissionSortType.rising: risingSubmissionSort,
    SubmissionSortType.top: topSubmissionSort,
    SubmissionSortType.controversial: controversialSubmissionSort,
  };
  // final SortOptionsRepository sortOptionsRepository = SortOptionsRepository();

  SubredditPageBloc(
      {@required this.getRedditLinks,
      @required this.subreddit,
      @required this.actionService})
      : assert(subreddit != null),
        super(
          SubredditPageInitial(
              subreddit: subreddit, currentSort: hotSubmissionSort),
        );

  @override
  Stream<Transition<SubredditPageEvent, SubredditPageState>> transformEvents(
    Stream<SubredditPageEvent> events,
    TransitionFunction<SubredditPageEvent, SubredditPageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 0)),
      transitionFn,
    );
  }

  @override
  Stream<SubredditPageState> mapEventToState(SubredditPageEvent event) async* {
    if (event is LoadSubmissions) {
      yield* _mapLoadSubmissionsToState(event: event);
    } else if (event is LoadMore) {
      yield* _mapLoadMoreToState();
    } else if (event is UserTappedSortButton) {
      yield* _mapUserTappedSortButtonToState();
    } else if (event is UserSelectedSortOption) {
      yield* _mapUserSelectedSortOptionToState(event);
    } else if (event is UserSelectedFilterOption) {
      yield* _mapUserSelectedFilterOptionToState(event);
    } else if (event is UserTappedActionsButton) {
      yield* _mapUserTappedActionsButtonToState();
    } else if (event is UserSelectedAction) {
      yield* _mapUserSelectedActionToState(event);
    }
  }

  Stream<SubredditPageState> _mapUserSelectedActionToState(
      UserSelectedAction event) async* {
    yield* event.action.action(this);
  }

  Stream<SubredditPageState> _mapUserTappedActionsButtonToState() async* {
    final actions = actionService
        .getActions(state.subreddit)
        .map((e) => e.toAction(this))
        .toList(growable: false);
    yield DisplayingActions(
        currentSort: state.currentSort,
        redditLinks: state.redditLinks,
        subreddit: state.subreddit,
        actions: actions);
  }

  Stream<SubredditPageState> _mapUserSelectedFilterOptionToState(
      UserSelectedFilterOption event) async* {
    final newSort = event.sort.copyWith(selectedFilter: Some(event.filter));
    yield SubredditPageLoading(
        subreddit: state.subreddit, currentSort: newSort);
    final failureOrSubmissions = await getRedditLinks(GetRedditLinksParams(
        subreddit: this.subreddit,
        filter: event.filter.type,
        sort: event.sort.type));

    yield* failureOrSubmissions.fold(
      (left) async* {
        print(left);
      },
      (redditLinks) async* {
        yield SubredditPageLoaded(
            subreddit: this.subreddit,
            redditLinks: redditLinks,
            currentSort: newSort);
      },
    );
  }

  Stream<SubredditPageState> _mapUserSelectedSortOptionToState(
      UserSelectedSortOption event) async* {
    yield* event.sort.filtersOptions.fold(() async* {
      yield* _mapLoadSubmissionsToState(
          event: LoadSubmissions(sort: event.sort.type));
    }, (options) async* {
      await Future.delayed(
        Duration(milliseconds: 200),
      );

      yield DisplayingSortOptions(
          redditLinks: state.redditLinks,
          currentSort: state.currentSort,
          subreddit: state.subreddit,
          options: options
              .map<ActionModel>(
                  (type) => createFilterAction(this, event.sort, type))
              .toList(growable: false));
    });
  }

  Stream<SubredditPageState> _mapUserTappedSortButtonToState() async* {
    yield DisplayingSortOptions(
        redditLinks: state.redditLinks,
        currentSort: state.currentSort,
        subreddit: state.subreddit,
        options: _sortOptions.values
            .map((SubmissionSort sort) =>
                sort.type == state.currentSort.type ? state.currentSort : sort)
            .map((SubmissionSort sort) => createSortAction(this, sort))
            .toList(growable: false));
  }

  Stream<SubredditPageState> _mapLoadSubmissionsToState(
      {LoadSubmissions event}) async* {
    yield SubredditPageLoading(
        subreddit: subreddit, currentSort: _sortOptions[event.sort]);

    final Either<Failure, List> failureOrSubmissions = await getRedditLinks(
        GetRedditLinksParams(
            subreddit: this.subreddit, filter: event.filter, sort: event.sort));

    yield* failureOrSubmissions.fold(
      (left) async* {
        print(left);
      },
      (submissions) async* {
        yield SubredditPageLoaded(
            subreddit: this.subreddit,
            redditLinks: (failureOrSubmissions as Right).value,
            currentSort: _sortOptions[event.sort]);
      },
    );
  }

  Stream<SubredditPageState> _mapLoadMoreToState() async* {
    if (state is SubredditPageLoaded) {
      final s = state as SubredditPageLoaded;
      final lastSubmission = s.redditLinks.last;
      final failureOrSubmissions = await getRedditLinks(GetRedditLinksParams(
          sort: state.currentSort.type,
          subreddit: this.subreddit,
          after: lastSubmission.id));

      yield* failureOrSubmissions.fold((left) async* {
        print(left.message);
      }, (right) async* {
        yield s.copyWith(redditLinks: s.redditLinks + right);
      });
    }
  }
}

final createFilterAction =
    (SubredditPageBloc bloc, SubmissionSort sort, SubmissionFilter filter) =>
        ActionModel(
          () {
            bloc.add(UserSelectedFilterOption(sort: sort, filter: filter));
          },
          filter.icon,
          filter.description,
        );

final createSortAction = (SubredditPageBloc bloc, SubmissionSort sort) =>
    ActionModel(() {
      bloc.add(UserSelectedSortOption(sort: sort));
    }, sort.icon, sort.description,
        selected: bloc.state.currentSort.type == sort.type,
        hasOptions: sort.filtersOptions.fold(() => false, (_) => true));

class ActionModel extends Equatable {
  final Function action;
  final String description;
  final DragoIcons icon;
  final bool selected;
  final bool hasOptions;

  ActionModel(this.action, this.icon, this.description,
      {this.selected = false, this.hasOptions = false});

  @override
  List<Object> get props => [action, description];
}

// typedef StateStream<S, B> = Stream<S> Function(B bloc);
typedef StateStream<S> = Stream<S> Function(dynamic);

class ActionModel2<S, B> extends Equatable {
  // final StateStream<S, B> action;
  final StateStream action;
  final String description;
  final DragoIcons icon;
  final bool selected;
  final bool hasOptions;

  ActionModel2(this.action, this.icon, this.description,
      {this.selected = false, this.hasOptions = false});

  @override
  List<Object> get props => [action, description];
}

class ActionService {
  List<Actionable> _actions = [];
  ActionService();

  List<Actionable> getActions(String subreddit) => _actions;
  ActionService add(Actionable action) {
    _actions.add(action);
    return this;
  }
}

// abstract class Actionable<S, B extends Bloc> {
//   ActionModel2<S, B> toAction(B bloc);
// }
abstract class Actionable<S, B extends Bloc> {
  ActionModel2<S, B> toAction(B bloc);
}

class SubscribeToSubredditAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  SubscribeToSubreddit usecase;

  SubscribeToSubredditAction(this.usecase) : assert(usecase != null);

  // @override
  // ActionModel2<SubredditPageState, SubredditPageBloc> toAction(
  //         SubredditPageBloc bloc) =>
  //     ActionModel2(
  //         (SubredditPageBloc bloc) => _states(bloc), null, "Subscribe");

  @override
  ActionModel2<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel2((bloc) => _states(bloc), null, "Subscribe");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure =
        await usecase(SubscribeToSubredditParams(bloc.subreddit));
    yield* unitOrFailure.fold((failure) async* {
      print(failure.message);
      yield SubredditPageLoaded(
          currentSort: bloc.state.currentSort,
          redditLinks: bloc.state.redditLinks,
          subreddit: bloc.state.subreddit);
    }, (_) async* {
      print('SUBSCRIBED TO ${bloc.subreddit}');
      yield SubredditPageLoaded(
          currentSort: bloc.state.currentSort,
          redditLinks: bloc.state.redditLinks,
          subreddit: bloc.state.subreddit);
    });
  }
}
