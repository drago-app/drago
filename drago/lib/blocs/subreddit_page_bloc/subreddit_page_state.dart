import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/features/subreddit/get_reddit_links.dart';

abstract class SubredditPageState extends Equatable {
  String get subreddit;
  SubmissionSortType get currentSort;
  List<RedditLink> get redditLinks;

  @override
  List<Object> get props => [subreddit, currentSort];
}

class SubredditPageInitial extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<RedditLink> redditLinks;

  SubredditPageInitial(
      {@required this.subreddit,
      @required this.currentSort,
      this.redditLinks = const []})
      : assert(subreddit != null);
}

class SubredditPageLoading extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<RedditLink> redditLinks;

  SubredditPageLoading(
      {@required this.subreddit,
      @required this.currentSort,
      this.redditLinks = const []})
      : assert(subreddit != null);
}

class SubredditPageLoaded extends SubredditPageState {
  final List<RedditLink> redditLinks;
  final String subreddit;
  final SubmissionSortType currentSort;

  SubredditPageLoaded(
      {@required this.redditLinks,
      @required this.subreddit,
      @required this.currentSort})
      : assert(redditLinks != null);

  SubredditPageLoaded copyWith({submissions, subreddit}) {
    return SubredditPageLoaded(
        currentSort: currentSort ?? this.currentSort,
        redditLinks: submissions ?? this.redditLinks,
        subreddit: subreddit ?? this.subreddit);
  }

  @override
  List<Object> get props => [redditLinks, subreddit, currentSort];
}

class DisplayingSortOptions extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<SubmissionSortOption> options;
  final List<RedditLink> redditLinks;

  DisplayingSortOptions(
      {@required this.subreddit,
      this.redditLinks = const [],
      @required this.currentSort,
      @required this.options});
  @override
  List<Object> get props => [subreddit, currentSort, options, redditLinks];
}

class DisplayingFilterOptions extends SubredditPageState {
  final String subreddit;
  final SubmissionSortType currentSort;
  final List<TimeFilterOption> options;
  final List<RedditLink> redditLinks;
  final SubmissionSortType sortType;

  DisplayingFilterOptions(
      {@required this.subreddit,
      this.redditLinks = const [],
      @required this.sortType,
      @required this.currentSort,
      @required this.options});
  @override
  List<Object> get props => [subreddit, currentSort, options, redditLinks];
}
