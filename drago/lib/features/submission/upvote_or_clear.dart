import 'package:dartz/dartz.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/vote_state.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

import '../../user_service.dart';

class UpvoteOrClear implements UseCase<Submission, VoteParams> {
  final RedditService reddit;
  final UserService userService;

  UpvoteOrClear({@required this.reddit, @required this.userService});

  @override
  Future<Either<Failure, Submission>> call(params) async {
    if (!await userService.isUserLoggedIn()) {
      return Left(NotAuthorizedFailure());
    }

    if (params.submission.voteState == VoteState.Up) {
      reddit.clearVote(params.submission);

      return Right(params.submission.copyWith(voteState: VoteState.Neutral));
    } else {
      reddit.upvote(params.submission);
      return Right(params.submission.copyWith(voteState: VoteState.Up));
    }
  }
}

class VoteParams {
  final Submission submission;

  VoteParams({@required this.submission}) : assert(submission != null);
}
