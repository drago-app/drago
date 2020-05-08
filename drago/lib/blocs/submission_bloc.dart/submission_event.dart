import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';

abstract class SubmissionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Upvote extends SubmissionEvent {}

class Downvote extends SubmissionEvent {}

class Save extends SubmissionEvent {}
