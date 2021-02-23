import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'subreddit_page_bloc.dart';

abstract class SubredditPageState extends Equatable {
  String get subreddit;
  SubmissionSort get currentSort;
  List<RedditLink> get redditLinks;

  @override
  List<Object> get props => [subreddit, currentSort];
}

class SubredditPageInitial extends SubredditPageState {
  final String subreddit;
  final SubmissionSort currentSort;
  final List<RedditLink> redditLinks;

  SubredditPageInitial(
      {@required this.subreddit,
      @required this.currentSort,
      this.redditLinks = const []})
      : assert(subreddit != null);
}

class SubredditPageLoading extends SubredditPageState {
  final String subreddit;
  final SubmissionSort currentSort;
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
  final SubmissionSort currentSort;

  SubredditPageLoaded(
      {@required this.redditLinks,
      @required this.subreddit,
      @required this.currentSort})
      : assert(redditLinks != null);

  SubredditPageLoaded copyWith({redditLinks, subreddit}) {
    return SubredditPageLoaded(
        currentSort: currentSort ?? this.currentSort,
        redditLinks: redditLinks ?? this.redditLinks,
        subreddit: subreddit ?? this.subreddit);
  }

  @override
  List<Object> get props => [redditLinks, subreddit, currentSort];
}

class DisplayingSortOptions extends SubredditPageState {
  final String subreddit;
  final SubmissionSort currentSort;
  final List<ActionModel> options;
  final List<RedditLink> redditLinks;

  DisplayingSortOptions(
      {@required this.subreddit,
      this.redditLinks = const [],
      @required this.currentSort,
      @required this.options});
  @override
  List<Object> get props => [subreddit, currentSort, options, redditLinks];
}

// class DisplayingFilterOptions extends SubredditPageState {
//   final String subreddit;
//   final SubmissionSort currentSort;
//   final List<TimeFilterOption> options;
//   final List<RedditLink> redditLinks;
//   final SubmissionSort sortType;

//   DisplayingFilterOptions(
//       {@required this.subreddit,
//       this.redditLinks = const [],
//       @required this.sortType,
//       @required this.currentSort,
//       @required this.options});
//   @override
//   List<Object> get props => [subreddit, currentSort, options, redditLinks];
// }
