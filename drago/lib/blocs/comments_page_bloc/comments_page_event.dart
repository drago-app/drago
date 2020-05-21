import 'package:drago/models/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class CommentsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadComments extends CommentsPageEvent {}

class ExpandComment extends CommentsPageEvent {
  final MoreCommentsModel comment;

  ExpandComment(this.comment);
}
