import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drago/blocs/comment_bloc/comment.dart';

import 'package:drago/core/error/failures.dart';
import 'package:drago/features/comment/get_more_comments.dart';

import 'package:drago/models/comment_model.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final BaseCommentModel comment;
  final GetMoreComments getMoreComments;

  CommentBloc({@required this.comment, @required this.getMoreComments});

  @override
  get initialState => CommentInitial(comment: comment);

  // @override
  // Stream<Transition<CommentEvent, CommentState>> transformEvents(
  //   Stream<CommentEvent> events,
  //   TransitionFunction<CommentEvent, CommentState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {}

  // Stream<CommentState> _mapLoadMoreCommentsToState(
  //     LoadMoreComments event) async* {
  //   yield CommentsLoading(comment);

  //   final failureOrComments = await getMoreComments(
  //       GetMoreCommentsParams(event.submissionId, event.data));

  //   yield* failureOrComments.fold((failure) async* {
  //     print('[CommentBloc#_mapLoadMoreCommentsToState] -- ${failure.message}');
  //   }, (comments) async* {
  //     yield CommentsLoaded(comment: comment, comments: comments);
  //   });
  // }
}
