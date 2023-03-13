import 'package:dartz/dartz.dart';
import 'package:drago/core/entities/subreddit.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetUsersSubscriptions implements UseCase<List, NoParams> {
  final RedditService reddit;

  GetUsersSubscriptions({required this.reddit});

  @override
  Future<Either<Failure, List<Subreddit>>> call(params) async {
    return await reddit.subscriptions();
  }
}
