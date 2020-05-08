import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/core/error/failures.dart';
import 'package:helius/core/usecases/usecase.dart';
import 'package:helius/reddit_service.dart';

class UpvoteOrClear implements UseCase<SubmissionModel, VoteParams> {
  final RedditService reddit;

  UpvoteOrClear({@required this.reddit});

  @override
  Future<Either<Failure, SubmissionModel>> call(params) async {
    if (params.submission.voteState == VoteState_.Up) {
      reddit.clearVote(params.submission);

      return Right(params.submission.copyWith(voteState: VoteState_.Neutral));
    } else {
      reddit.upvote(params.submission);
      return Right(params.submission.copyWith(voteState: VoteState_.Up));
    }
  }
}

class VoteParams {
  final SubmissionModel submission;

  VoteParams({@required this.submission}) : assert(submission != null);
}
