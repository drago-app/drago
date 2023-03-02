import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:equatable/equatable.dart';

abstract class SubmissionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Upvote extends SubmissionEvent {}

class Downvote extends SubmissionEvent {}

class Save extends SubmissionEvent {}

class DialogDismissed extends SubmissionEvent {}

class SubmissionResolved extends SubmissionEvent {
  final Submission submission;

  SubmissionResolved({required this.submission});

  @override
  List<Object> get props => [submission];
}
