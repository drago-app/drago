import 'package:drago/blocs/subreddit_page_bloc/subreddit_page.dart';
import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';

abstract class SubredditPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSubmissions extends SubredditPageEvent {
  final SubmissionSortType sort;
  final TimeFilter filter;

  LoadSubmissions(
      {this.sort = SubmissionSortType.hot, this.filter = TimeFilter.all});
}

class LoadMore extends SubredditPageEvent {}

class UserTappedSortButton extends SubredditPageEvent {}

class UserTappedActionsButton extends SubredditPageEvent {}

class UserSelectedAction extends SubredditPageEvent {
  final ActionModel action;

  UserSelectedAction(this.action) : assert(action != null);
  List<Object> get props => [action];
}
