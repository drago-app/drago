import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:drago/core/error/failures.dart';
import 'package:drago/features/comment/get_more_comments.dart';

import 'package:drago/models/comment_model.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'more_comments.dart';

class MoreCommentsBloc extends Bloc<MoreCommentsEvent, MoreCommentsState> {
  final MoreCommentsModel more;
  final GetMoreComments getMoreComments;

  MoreCommentsBloc({@required this.more, @required this.getMoreComments})
      : super(MoreCommentsInitial(more: more));

  @override
  Stream<MoreCommentsState> mapEventToState(MoreCommentsEvent event) async* {
    if (event is LoadMoreComments) yield* _mapLoadMoreCommentsToState();
  }

  Stream<MoreCommentsState> _mapLoadMoreCommentsToState() async* {
    yield MoreCommentsLoading(more: more);

    final failureOrComments = await getMoreComments(
        GetMoreCommentsParams(more.submissionId, more.data));

    yield* failureOrComments.fold((failure) async* {
      print(
          '[MoreCommentsBloc#_mapLoadMoreCommentsToState] -- ${failure.message}');
    }, (comments) async* {
      yield MoreCommentsLoaded(more: more, expandedComments: comments);
    });
  }
}
