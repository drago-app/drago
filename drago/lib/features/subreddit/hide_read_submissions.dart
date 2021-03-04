import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class HideReadSubmissions implements UseCase<Unit, HideReadSubmissionsParams> {
  final RedditService reddit;

  HideReadSubmissions({@required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(HideReadSubmissionsParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class HideReadSubmissionsParams {
  final String subreddit;
  HideReadSubmissionsParams(this.subreddit) : assert(subreddit != null);
}
