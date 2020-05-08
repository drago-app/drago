import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/error/failures.dart';
import 'package:helius/core/usecases/usecase.dart';
import 'package:helius/reddit_service.dart';

class GetUsersModerations implements UseCase<List, NoParams> {
  final RedditService reddit;

  GetUsersModerations({@required this.reddit});

  @override
  Future<Either<Failure, List>> call(params) async {
    return await reddit.moderatedSubreddits();
  }
}
