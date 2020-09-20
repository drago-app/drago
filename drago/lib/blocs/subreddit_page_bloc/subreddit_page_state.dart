import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/features/subreddit/get_submissions.dart';

abstract class SubredditPageState extends Equatable {
  String get subreddit;
  SubmissionSortType get currentSort;
  List<Future<Submission>> get submissions;

  @override
  List<Object> get props => [subreddit, currentSort];
}

class SubredditPageInitial extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<Future<Submission>> submissions;

  SubredditPageInitial(
      {@required this.subreddit,
      @required this.currentSort,
      this.submissions = const []})
      : assert(subreddit != null);
}

class SubredditPageLoading extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<Future<Submission>> submissions;

  SubredditPageLoading(
      {@required this.subreddit,
      @required this.currentSort,
      this.submissions = const []})
      : assert(subreddit != null);
}

class SubredditPageLoaded extends SubredditPageState {
  final List<Future<Submission>> submissions;
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

class DisplayingSortOptions extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<SubmissionSortOption> options;
  final List<Future<Submission>> submissions;

  DisplayingSortOptions(
      {@required this.subreddit,
      this.submissions = const [],
      @required this.currentSort,
      @required this.options});
  @override
  List<Object> get props => [subreddit, currentSort, options, submissions];
}

class DisplayingFilterOptions extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<TimeFilterOption> options;
  final List<Future<Submission>> submissions;
  final SubmissionSortType sortType;

  DisplayingFilterOptions(
      {@required this.subreddit,
      this.submissions = const [],
      @required this.sortType,
      @required this.currentSort,
      @required this.options});
  @override
  List<Object> get props => [subreddit, currentSort, options, submissions];
}
