import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter/foundation.dart';

class SetUserFlair implements UseCase<Unit, SetUserFlairParams> {
  final RedditService reddit;

  SetUserFlair({@required this.reddit});

  @override
  Future<Either<Failure, Unit>> call(SetUserFlairParams params) async {
    return Future.value(Left(SomeFailure(message: "Feature not implemented")));
  }
}

class SetUserFlairParams {
  final String subreddit;
  SetUserFlairParams(this.subreddit) : assert(subreddit != null);
}
