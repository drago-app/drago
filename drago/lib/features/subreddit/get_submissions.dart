import 'package:dartz/dartz.dart';
import 'package:drago/models/sort_option.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetSubmissions
    implements UseCase<List<SubmissionModel>, GetSubmissionsParams> {
  final RedditService reddit;

  GetSubmissions({@required this.reddit});

  @override
  Future<Either<Failure, List<SubmissionModel>>> call(
      GetSubmissionsParams params) async {
    return await reddit.getSubmissions(params.subreddit,
        sort: params.sort, after: params.after, filter: params.filter);
  }
}

class GetSubmissionsParams {
  final String after;
  final String subreddit;
  final SubmissionSortType sort;
  final TimeFilter_ filter;

  GetSubmissionsParams(
      {@required this.subreddit, this.sort, this.filter, this.after});
}
