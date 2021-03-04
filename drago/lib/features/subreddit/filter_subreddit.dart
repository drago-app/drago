import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class FilterSubreddit implements UseCase<Unit, FilterSubredditParams> {
  final RedditService reddit;

  FilterSubreddit({@required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(FilterSubredditParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class FilterSubredditParams {
  final String subreddit;
  FilterSubredditParams(this.subreddit) : assert(subreddit != null);
}
