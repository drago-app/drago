import 'package:drago/features/subreddit/get_reddit_links.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:drago/core/entities/submission_entity.dart';

abstract class SubmissionState extends Equatable {
  Submission get submission;

  SubmissionState copyWith({submission});

  @override
  List<Object> get props => [submission];
}

class SubmissionInitial extends SubmissionState {
  final Submission submission;

  SubmissionInitial({@required this.submission}) : assert(submission != null);

  SubmissionInitial copyWith({submission}) {
    return SubmissionInitial(submission: submission ?? this.submission);
  }

  @override
  List<Object> get props => [submission];
}

class SubmissionAuthError extends SubmissionState {
  final Submission submission;
  final String title;
  final String content;

  SubmissionAuthError(
      {@required this.submission, @required this.title, this.content});

  @override
  SubmissionAuthError copyWith({submission, title}) {
    return SubmissionAuthError(
      submission: submission ?? this.submission,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
