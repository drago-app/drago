import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMoreComments extends CommentEvent {
  final Map data;
  LoadMoreComments(this.data) : assert(data != null);

  @override
  List<Object> get props => [data];
}
