import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:drago/models/comment_model.dart';
import 'package:drago/sandbox/types.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetMoreComments
    implements UseCase<List<BaseCommentModel>, GetMoreCommentsParams> {
  final RedditService reddit;

  GetMoreComments({required this.reddit});

  @override
  Future<Either<Failure, List<BaseCommentModel>>> call(params) async {
    final List<Either<More, RedditComment>> failureOrComments =
        await (reddit.getMoreComments(params.data, params.submissionId)
            as FutureOr<List<Either<More, RedditComment>>>);

    final List<BaseCommentModel> comments = failureOrComments
        .map((moc) => moc.fold(
              (more) => BaseCommentModel.fromMore(more, params.submissionId),
              (comment) => BaseCommentModel.fromRedditComment(
                  comment, params.submissionId),
            ))
        .toList();

    return Right(comments);
  }
}

class GetMoreCommentsParams {
  final String submissionId;
  final Map data;
  GetMoreCommentsParams(this.submissionId, this.data);
}
