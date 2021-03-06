import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

import '../../user_service.dart';

class DownvoteOrClear implements UseCase<SubmissionModel, DownVoteParams> {
  final RedditService reddit;
  final UserService userService;

  DownvoteOrClear({@required this.reddit, @required this.userService});

  @override
  Future<Either<Failure, SubmissionModel>> call(params) async {
    if (!await userService.isUserLoggedIn()) {
      return Left(NotAuthorizedFailure());
    }

    if (params.submission.voteState == VoteState_.Down) {
      reddit.clearVote(params.submission);

      return Right(
        params.submission.copyWith(
          metaData: params.submission.metaData
              .copyWith(voteState: VoteState_.Neutral),
        ),
      );
    } else {
      reddit.downvote(params.submission);
      return Right(
        params.submission.copyWith(
          metaData:
              params.submission.metaData.copyWith(voteState: VoteState_.Down),
        ),
      );
    }
  }
}

class DownVoteParams {
  final SubmissionModel submission;

  DownVoteParams({@required this.submission}) : assert(submission != null);
}
