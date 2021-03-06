import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

import '../../user_service.dart';

class SaveOrUnsaveSubmission
    implements UseCase<SubmissionModel, SaveOrUnsaveParams> {
  final RedditService reddit;
  final UserService userService;

  SaveOrUnsaveSubmission({@required this.reddit, @required this.userService});

  @override
  Future<Either<Failure, SubmissionModel>> call(params) async {
    if (!await userService.isUserLoggedIn()) {
      return Left(NotAuthorizedFailure());
    }

    if (params.submission.saved) {
      return await reddit.unsaveSubmission(params.submission);
    } else {
      return await reddit.saveSubmission(params.submission);
    }
  }
}

class SaveOrUnsaveParams {
  final SubmissionModel submission;

  SaveOrUnsaveParams({@required this.submission}) : assert(submission != null);
}
