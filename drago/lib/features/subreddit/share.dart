import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class Share implements UseCase<Unit, ShareParams> {
  final RedditService reddit;

  Share({@required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(ShareParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class ShareParams {
  final String subreddit;
  ShareParams(this.subreddit) : assert(subreddit != null);
}
