import 'package:dartz/dartz.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/vote_state.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

import '../../user_service.dart';

class DownvoteOrClear implements UseCase<Submission, DownVoteParams> {
  final RedditService reddit;
  final UserService userService;

  DownvoteOrClear({@required this.reddit, @required this.userService});

  @override
  Future<Either<Failure, Submission>> call(params) async {
    if (!await userService.isUserLoggedIn()) {
      return Left(NotAuthorizedFailure());
    }
    if (params.submission.archived) {
      return Left(PostArchivedFailure());
    }

    if (params.submission.voteState == VoteState.Down) {
      reddit.clearVote(params.submission);

      return Right(
        params.submission.copyWith(voteState: VoteState.Neutral),
      );
    } else {
      reddit.downvote(params.submission);
      return Right(
        params.submission.copyWith(voteState: VoteState.Down),
      );
    }
  }
}

class DownVoteParams {
  final Submission submission;

  DownVoteParams({@required this.submission}) : assert(submission != null);
}
