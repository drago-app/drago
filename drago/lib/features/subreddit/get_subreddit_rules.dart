

import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class GetSubredditRules implements UseCase<Unit, GetSubredditRulesParams> {
  final RedditService reddit;

  GetSubredditRules({required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(GetSubredditRulesParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class GetSubredditRulesParams {
  final String subreddit;
  GetSubredditRulesParams(this.subreddit) : assert(subreddit != null);
}
