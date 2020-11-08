import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/blocs/comment_bloc/comment.dart';

import 'package:drago/core/error/failures.dart';

import 'package:drago/models/comment_model.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final BaseCommentModel comment;

  CommentBloc({@required this.comment});

  @override
  get initialState => CommentInitial(comment: comment);

  @override
  Stream<Transition<CommentEvent, CommentState>> transformEvents(
    Stream<CommentEvent> events,
    TransitionFunction<CommentEvent, CommentState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {}
}
