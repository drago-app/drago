import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/reddit_service.dart';
import 'package:meta/meta.dart';
import './subreddit_page.dart';
import 'package:rxdart/rxdart.dart';

class SubredditPageBloc extends Bloc<SubredditPageEvent, SubredditPageState> {
  final RedditService reddit;
  final String subreddit;

  SubredditPageBloc({@required this.reddit, @required this.subreddit});

  @override
  get initialState => SubredditPageInitial(subreddit: this.subreddit);

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
      yield* _mapLoadSubmissionsToState();
    } else if (event is LoadMore) {
      yield* _mapLoadMoreToState();
    }
  }

  Stream<SubredditPageState> _mapLoadSubmissionsToState() async* {
    yield SubredditPageLoading(subreddit: subreddit);
    final List submissions = await reddit.getSubmissions(this.subreddit);
    yield SubredditPageLoaded(subreddit: subreddit, submissions: submissions);
  }

  Stream<SubredditPageState> _mapLoadMoreToState() async* {
    if (state is SubredditPageLoaded) {
      final s = state as SubredditPageLoaded;
      final lastSubmission = s.submissions.last;
      final List moreSubmissions =
          await reddit.getSubmissions(this.subreddit, after: lastSubmission.id);
      yield s.copyWith(submissions: s.submissions + moreSubmissions);
    }
  }
}
