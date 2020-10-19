import 'package:dartz/dartz.dart';
import 'package:drago/sandbox/types.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetUserProfile implements UseCase<RedditAccount, GetUserProfileParams> {
  final RedditService reddit;

  GetUserProfile({@required this.reddit});

  @override
  Future<Either<Failure, RedditAccount>> call(params) async {
    return reddit.getUser(params.userName);
  }
}

class GetUserProfileParams {
  final String userName;

  GetUserProfileParams({@required this.userName}) : assert(userName != null);
}
