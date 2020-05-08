import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';

abstract class SubmissionState extends Equatable {
  SubmissionModel get submission;

  @override
  List<Object> get props => [];
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
