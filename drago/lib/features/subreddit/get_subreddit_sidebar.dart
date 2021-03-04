import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class GetSubredditSidebar implements UseCase<Unit, GetSubredditSidebarParams> {
  final RedditService reddit;

  GetSubredditSidebar({@required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(GetSubredditSidebarParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class GetSubredditSidebarParams {
  final String subreddit;
  GetSubredditSidebarParams(this.subreddit) : assert(subreddit != null);
}
