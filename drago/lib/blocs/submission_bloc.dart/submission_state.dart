import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:equatable/equatable.dart';

abstract class SubmissionState extends Equatable {
  Submission get submission;

  SubmissionState copyWith({submission});

  @override
  List<Object> get props => [submission];
}

class SubmissionInitial extends SubmissionState {
  final Submission submission;

  SubmissionInitial({required this.submission});

  SubmissionInitial copyWith({submission}) {
    return SubmissionInitial(submission: submission ?? this.submission);
  }

  @override
  List<Object> get props => [submission];
}

class SubmissionAuthError extends SubmissionState {
  final Submission submission;
  final String title;
  final String? content;

  SubmissionAuthError(
      {required this.submission, required this.title, this.content});

  @override
  SubmissionAuthError copyWith({submission, title}) {
    return SubmissionAuthError(
      submission: submission ?? this.submission,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

class SubmissionActionError extends SubmissionState {
  final Submission submission;
  final String? title;
  final String? content;

  SubmissionActionError(
      {required this.submission, required this.title, this.content});

  @override
  SubmissionActionError copyWith({submission, title}) {
    return SubmissionActionError(
      submission: submission ?? this.submission,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
