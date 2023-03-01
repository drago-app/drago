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
  final ActionService<SortSubmissionsAction> sortActionsService;
  final Map<SubmissionSortType, SubmissionSort> _sortOptions = {
    SubmissionSortType.hot: hotSubmissionSort,
    SubmissionSortType.newest: newestSubmissionSort,
    SubmissionSortType.rising: risingSubmissionSort,
    SubmissionSortType.top: topSubmissionSort,
    SubmissionSortType.controversial: controversialSubmissionSort,
  };

  SubredditPageBloc(
      {required this.getRedditLinks,
      required this.subreddit,
      required this.actionService,
      required this.sortActionsService})
      : assert(subreddit != null),
        super(
          SubredditPageInitial(
              subreddit: subreddit, currentSort: hotSubmissionSort),
        );

  // @override
  // Stream<Transition<SubredditPageEvent, SubredditPageState>> transformEvents(
  //   Stream<SubredditPageEvent> events,
  //   TransitionFunction<SubredditPageEvent, SubredditPageState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 0)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<SubredditPageState> mapEventToState(SubredditPageEvent event) async* {
    if (event is LoadSubmissions) {
      yield* _mapLoadSubmissionsToState(event: event);
    } else if (event is LoadMore) {
      yield* _mapLoadMoreToState();
    } else if (event is UserTappedSortButton) {
      yield* _mapUserTappedSortButtonToState();
    } else if (event is UserTappedActionsButton) {
      yield* _mapUserTappedActionsButtonToState();
    } else if (event is UserSelectedAction) {
      yield* _mapUserSelectedActionToState(event);
    }
  }

  Stream<SubredditPageState> _mapUserSelectedActionToState(
      UserSelectedAction event) async* {
    yield* event.action.action(this) as Stream<SubredditPageState>;
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

  Stream<SubredditPageState> _mapUserTappedSortButtonToState() async* {
    yield DisplayingActions(
      redditLinks: state.redditLinks,
      currentSort: state.currentSort,
      subreddit: state.subreddit,
      actions: sortActionsService
          .getActions(state.subreddit)
          .map((a) => a.toAction(this))
          .toList(),
    );
  }

  Stream<SubredditPageState> _mapLoadSubmissionsToState(
      {required LoadSubmissions event}) async* {
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
            redditLinks: (failureOrSubmissions as Right)
                .value, // just use 'submissions'???
            currentSort: _sortOptions[event.sort]);
      },
    );
  }

  Stream<SubredditPageState> _mapLoadMoreToState() async* {
    if (state is SubredditPageLoaded) {
      final s = state as SubredditPageLoaded;
      final lastSubmission = s.redditLinks.last;
      final failureOrSubmissions = await getRedditLinks(GetRedditLinksParams(
          sort: state.currentSort!.type,
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

class ActionService<A extends Actionable> {
  List<A> _actions = [];

  List<A> getActions(String? subreddit) => _actions;
  ActionService add(Actionable action) {
    _actions.add(action as A);
    return this;
  }
}

typedef StateStream<S> = Stream<S> Function(dynamic);

class ActionModel<S, B> extends Equatable {
  final StateStream action;
  final String description;
  final DragoIcons icon;
  final bool? selected;
  final Option<List<ActionableFn>> options;

  ActionModel(this.action, this.icon, this.description,
      {this.selected = false, this.options = const None()});

  @override
  List<Object> get props => [action, description];
}

abstract class Actionable<S, B extends Bloc> {
  ActionModel<S, B> toAction(B bloc);
}

typedef ActionableFn = Actionable Function(dynamic);
