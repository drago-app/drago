import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SubredditPageState extends Equatable {
  String get subreddit;

  @override
  List<Object> get props => [];
}

class SubredditPageInitial extends SubredditPageState {
  final String subreddit;

  SubredditPageInitial({@required this.subreddit}) : assert(subreddit != null);
}

class SubredditPageLoading extends SubredditPageState {
  final String subreddit;

  SubredditPageLoading({@required this.subreddit}) : assert(subreddit != null);
}

class SubredditPageLoaded extends SubredditPageState {
  final List submissions;
  final String subreddit;

  SubredditPageLoaded({@required this.submissions, @required this.subreddit})
      : assert(submissions != null);

  SubredditPageLoaded copyWith({submissions, subreddit}) {
    return SubredditPageLoaded(
        submissions: submissions ?? this.submissions,
        subreddit: subreddit ?? this.subreddit);
  }

  @override
  List<Object> get props => [submissions, subreddit];
}
