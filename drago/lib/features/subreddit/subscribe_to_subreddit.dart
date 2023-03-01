

import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class SubscribeToSubreddit
    implements UseCase<Unit, SubscribeToSubredditParams> {
  final RedditService reddit;

  SubscribeToSubreddit({required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(SubscribeToSubredditParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class SubscribeToSubredditParams {
  final String subreddit;
  SubscribeToSubredditParams(this.subreddit) : assert(subreddit != null);
}
