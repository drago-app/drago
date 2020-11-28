import 'package:drago/models/comment_model.dart';
import 'package:flutter/foundation.dart';

abstract class MoreCommentsState {
  MoreCommentsModel get more;
  MoreCommentsState copyWith();
}

class MoreCommentsInitial extends MoreCommentsState {
  final MoreCommentsModel more;

  MoreCommentsInitial({@required this.more});

  @override
  MoreCommentsInitial copyWith({more}) {
    return MoreCommentsInitial(more: more ?? this.more);
  }
}

class MoreCommentsLoading extends MoreCommentsState {
  final MoreCommentsModel more;

  MoreCommentsLoading({@required this.more});

  @override
  MoreCommentsLoading copyWith({more}) {
    return MoreCommentsLoading(more: more ?? this.more);
  }
}

class MoreCommentsLoaded extends MoreCommentsState {
  final MoreCommentsModel more;
  final List expandedComments;

  MoreCommentsLoaded({@required this.more, @required this.expandedComments});

  @override
  MoreCommentsLoaded copyWith({more, expandedComments}) {
    return MoreCommentsLoaded(
        more: more ?? this.more,
        expandedComments: expandedComments ?? this.expandedComments);
  }
}
