import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/core/error/failures.dart';
import 'package:helius/core/usecases/usecase.dart';
import 'package:helius/reddit_service.dart';

class SaveOrUnsaveSubmission
    implements UseCase<SubmissionModel, SaveOrUnsaveParams> {
  final RedditService reddit;

  SaveOrUnsaveSubmission({@required this.reddit});

  @override
  Future<Either<Failure, SubmissionModel>> call(params) async {
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
