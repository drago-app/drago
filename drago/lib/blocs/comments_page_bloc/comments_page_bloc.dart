import 'dart:async';
import 'package:bloc/bloc.dart';
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

  CommentsPageBloc({@required this.reddit, @required this.submission});

  @override
  get initialState => CommentsPageInitial();

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
    final List<BaseCommentModel> comments =
        await reddit.getComments(submission.id);

    yield CommentsLoaded(comments: comments);
  }

  Stream<CommentsPageState> _mapExpandCommentToState(
      MoreCommentsModel comment) async* {
    final List comments = await reddit.getMoreComments(comment);

    yield CommentsLoaded(comments: comments);
  }
}
