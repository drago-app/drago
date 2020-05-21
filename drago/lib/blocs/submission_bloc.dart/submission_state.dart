import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';

abstract class SubmissionState extends Equatable {
  SubmissionModel get submission;

  SubmissionState copyWith({submission});

  @override
  List<Object> get props => [submission];
}

class SubmissionInitial extends SubmissionState {
  final SubmissionModel submission;

  SubmissionInitial({@required this.submission}) : assert(submission != null);

  SubmissionInitial copyWith({submission}) {
    return SubmissionInitial(submission: submission ?? this.submission);
  }

  @override
  List<Object> get props => [submission];
}

class SubmissionError extends SubmissionState {
  final SubmissionModel submission;
  final String title;
  final String content;

  SubmissionError(
      {@required this.submission, @required this.title, this.content});

  @override
  SubmissionError copyWith({submission, title}) {
    return SubmissionError(
      submission: submission ?? this.submission,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
