import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/sort_option.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import './subreddit_page.dart';
import 'package:rxdart/rxdart.dart';

class SubredditPageBloc extends Bloc<SubredditPageEvent, SubredditPageState> {
  final GetSubmissions getSubmissions;
  final String subreddit;
  final List<SubmissionSortOption> options = [
    SubmissionSortOption.factory(
      type: SubmissionSortType.hot,
    ),
    SubmissionSortOption.factory(type: SubmissionSortType.top),
    SubmissionSortOption.factory(type: SubmissionSortType.controversial),
    SubmissionSortOption.factory(type: SubmissionSortType.newest),
    SubmissionSortOption.factory(type: SubmissionSortType.rising),
  ];
  final List<TimeFilterOption> filters = [
    TimeFilterOption.factory(TimeFilter_.all),
    TimeFilterOption.factory(TimeFilter_.day),
    TimeFilterOption.factory(TimeFilter_.week),
    TimeFilterOption.factory(TimeFilter_.month),
    TimeFilterOption.factory(TimeFilter_.year),
  ];

  SubredditPageBloc({@required this.getSubmissions, @required this.subreddit});

  @override
  get initialState => SubredditPageInitial(
      subreddit: this.subreddit, currentSort: SubmissionSortType.hot);

  @override
  Stream<Transition<SubredditPageEvent, SubredditPageState>> transformEvents(
    Stream<SubredditPageEvent> events,
    TransitionFunction<SubredditPageEvent, SubredditPageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SubredditPageState> mapEventToState(SubredditPageEvent event) async* {
    if (event is LoadSubmissions) {
      yield* _mapLoadSubmissionsToState(sort: event.sort);
    } else if (event is LoadMore) {
      yield* _mapLoadMoreToState();
    } else if (event is UserTappedSortButton) {
      yield* _mapUserTappedSortButtonToState();
    } else if (event is UserSelectedSortOption) {
      yield* _mapUserSelectedSortOptionToState(event);
    }
  }

  Stream<SubredditPageState> _mapUserSelectedSortOptionToState(
      UserSelectedSortOption event) async* {
    if (event.sort.filterable) {
      yield DisplayingFilterOptions(
          sortType: event.sort.type,
          options: filters,
          subreddit: state.subreddit,
          submissions: state.submissions,
          currentSort: state.currentSort);
    } else {
      yield* _mapLoadSubmissionsToState(sort: event.sort.type);
    }
  }

  Stream<SubredditPageState> _mapUserTappedSortButtonToState() async* {
    yield DisplayingSortOptions(
        submissions: state.submissions,
        currentSort: state.currentSort,
        subreddit: state.subreddit,
        options: options);
  }

  Stream<SubredditPageState> _mapLoadSubmissionsToState(
      {SubmissionSortType sort, TimeFilter_ filter}) async* {
    yield SubredditPageLoading(
        subreddit: subreddit, currentSort: sort ?? state.currentSort);
    final Either<Failure, List> failureOrSubmissions = await getSubmissions(
        GetSubmissionsParams(
            subreddit: this.subreddit, filter: filter, sort: sort));

    if (failureOrSubmissions is Right) {
      yield SubredditPageLoaded(
        subreddit: this.subreddit,
        submissions: (failureOrSubmissions as Right).value,
        currentSort: sort ?? state.currentSort,
      );
    }
  }

  Stream<SubredditPageState> _mapLoadMoreToState() async* {
    if (state is SubredditPageLoaded) {
      final s = state as SubredditPageLoaded;
      final lastSubmission = s.submissions.last;

      final failureOrSubmissions = getSubmissions(GetSubmissionsParams(
          subreddit: this.subreddit, after: lastSubmission.id));
      if (failureOrSubmissions is Right) {
        yield s.copyWith(
            submissions: s.submissions + (failureOrSubmissions as Right).value);
      }
    }
  }
}
