import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMoreComments extends CommentEvent {
  final Map data;
  final String submissionId;
  LoadMoreComments(this.data, this.submissionId) : assert(data != null);

  @override
  List<Object> get props => [data, submissionId];
}
