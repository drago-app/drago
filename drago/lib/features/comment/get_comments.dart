import 'package:dartz/dartz.dart';
import 'package:drago/models/comment_model.dart';
import 'package:drago/sandbox/types.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetComments
    implements UseCase<List<BaseCommentModel>, GetCommentsParams> {
  final RedditService reddit;

  GetComments({@required this.reddit});

  @override
  Future<Either<Failure, List<BaseCommentModel>>> call(params) async {
    // final List<Either<More, RedditComment>> moreOrComments =
    //     await reddit.getComments(params.submissionId);

    final List<Either<More, RedditComment>> failureOrComments =
        await reddit.getComments(params.submissionId);

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

class GetCommentsParams {
  final String submissionId;

  GetCommentsParams(this.submissionId);
}
