import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/features/comment/get_comments.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/comment_model.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/reddit_service.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'comments_page.dart';

class CommentsPageBloc extends Bloc<CommentsPageEvent, CommentsPageState> {
  final RedditService reddit;
  final Submission submission;
  final GetComments getComments;

  CommentsPageBloc(
      {@required this.reddit,
      @required this.submission,
      @required this.getComments})
      : super(CommentsPageInitial());

  @override
  Stream<Transition<CommentsPageEvent, CommentsPageState>> transformEvents(
    Stream<CommentsPageEvent> events,
    TransitionFunction<CommentsPageEvent, CommentsPageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CommentsPageState> mapEventToState(CommentsPageEvent event) async* {
    if (event is LoadComments) yield* _mapLoadCommentsToState();
    if (event is ExpandComment) yield* _mapExpandCommentToState(event.comment);
  }

  Stream<CommentsPageState> _mapLoadCommentsToState() async* {
    final Either<Failure, List<BaseCommentModel>> commentsOrFailure =
        await getComments(GetCommentsParams(submission.id));

    yield* commentsOrFailure.fold(
      (left) async* {
        print('[CommentsPageBLoC#_mapLoadCommentsToState] \n ${left.message}');
      },
      (comments) async* {
        yield (CommentsLoaded(comments: comments));
      },
    );
  }

  Stream<CommentsPageState> _mapExpandCommentToState(
      MoreCommentsModel comment) async* {
    // final List comments = await reddit.getMoreComments(comment);

    // yield CommentsLoaded(comments: comments);
  }
}
