import 'package:drago/models/comment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class CommentState extends Equatable {
  BaseCommentModel get comment;

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {
  final BaseCommentModel comment;

  CommentInitial({@required this.comment});

  CommentInitial copyWith({comment}) {
    return CommentInitial(comment: comment ?? this.comment);
  }
}
