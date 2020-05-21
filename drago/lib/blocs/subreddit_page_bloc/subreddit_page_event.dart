import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';

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
