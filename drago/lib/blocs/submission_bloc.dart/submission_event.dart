import 'package:equatable/equatable.dart';

abstract class SubmissionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Upvote extends SubmissionEvent {}

class Downvote extends SubmissionEvent {}

class Save extends SubmissionEvent {}
