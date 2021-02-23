import 'package:drago/blocs/subreddit_page_bloc/subreddit_page.dart';
import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SubredditPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSubmissions extends SubredditPageEvent {
  final SubmissionSortType sort;
  final TimeFilter_ filter;

  LoadSubmissions(
      {this.sort = SubmissionSortType.hot, this.filter = TimeFilter_.all});
}

class LoadMore extends SubredditPageEvent {}

class UserTappedSortButton extends SubredditPageEvent {}

class UserSelectedSortOption extends SubredditPageEvent {
  final SubmissionSort sort;

  UserSelectedSortOption({@required this.sort});
  List<Object> get props => [sort];
}

class UserSelectedFilterOption extends SubredditPageEvent {
  final SubmissionSort sort;
  final SubmissionFilter filter;

  UserSelectedFilterOption({@required this.sort, @required this.filter})
      : assert(sort != null),
        assert(filter != null);
  List<Object> get props => [sort, filter];
}
