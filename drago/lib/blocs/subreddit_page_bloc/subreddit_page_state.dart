import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SubredditPageState extends Equatable {
  String get subreddit;
  SubmissionSortType get currentSort;

  @override
  List<Object> get props => [subreddit, currentSort];
}

class SubredditPageInitial extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;

  SubredditPageInitial({@required this.subreddit, @required this.currentSort})
      : assert(subreddit != null);
}

class SubredditPageLoading extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;

  SubredditPageLoading({@required this.subreddit, @required this.currentSort})
      : assert(subreddit != null);
}

class SubredditPageLoaded extends SubredditPageState {
  final List submissions;
  final String subreddit;
  final SubmissionSortType currentSort;

  SubredditPageLoaded(
      {@required this.submissions,
      @required this.subreddit,
      @required this.currentSort})
      : assert(submissions != null);

  SubredditPageLoaded copyWith({submissions, subreddit}) {
    return SubredditPageLoaded(
        currentSort: currentSort ?? this.currentSort,
        submissions: submissions ?? this.submissions,
        subreddit: subreddit ?? this.subreddit);
  }

  @override
  List<Object> get props => [submissions, subreddit, currentSort];
}
