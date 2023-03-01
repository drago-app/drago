

import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class SaveSubmissionSize implements UseCase<Unit, SaveSubmissionSizeParams> {
  final RedditService reddit;

  SaveSubmissionSize({required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(SaveSubmissionSizeParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class SaveSubmissionSizeParams {
  final String subreddit;
  SaveSubmissionSizeParams(this.subreddit) : assert(subreddit != null);
}
