import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

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
