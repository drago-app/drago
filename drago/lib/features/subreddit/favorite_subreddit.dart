

import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class FavoriteSubreddit implements UseCase<Unit, FavoriteSubredditParams> {
  final RedditService reddit;

  FavoriteSubreddit({required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(FavoriteSubredditParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class FavoriteSubredditParams {
  final String subreddit;
  FavoriteSubredditParams(this.subreddit) : assert(subreddit != null);
}
