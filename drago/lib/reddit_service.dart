import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:drago/draw_reddit_adapter.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/types.dart';
import 'package:drago/core/error/failures.dart';
import 'package:flutter/foundation.dart';
import 'user_service.dart';

class RedditService {
  final RedditClient redditClient;
  String _state = 'thisisarandomstring';

  RedditService({@required this.redditClient});

  Future<List<Either>> getMoreComments(Map data, String submissionId) async {
    final List<Map> jsonComments =
        await redditClient.expandMoreComments(data, submissionId);
    return RedditComment.buildComments(jsonComments);
  }

  Future<List<Either>> getComments(String submissionId) async {
    final List<Map> jsonComments =
        await redditClient.getCommentsForSubmission(submissionId);
    return RedditComment.buildComments(jsonComments);
  }

  Future<Either<Failure, List<String>>> defaultSubreddits() async {
    try {
      final subs = await redditClient.defaultSubreddits();
      return Right(
          subs..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(
          message: '[RedditService#defaultSubreddit] ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<String>>> subscriptions() async {
    try {
      final subs = await redditClient.subscriptions();
      return Right(
          subs..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(
          message: '[RedditService#subscriptions] ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<String>>> moderatedSubreddits() async {
    try {
      final subs = await redditClient.subscriptions();
      return Right(
          subs..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(
          message: '[RedditService#moderatedSubreddits] ${e.toString()}'));
    }
  }

  Future<Either<Failure, Unit>> saveSubmission(
      Submission submissionModel) async {
    try {
      await redditClient.saveSubmission(submissionModel.id);
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> unsaveSubmission(
      Submission submissionModel) async {
    try {
      await redditClient.unsaveSubmission(submissionModel.id);
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> downvote(Submission submissionModel) async {
    try {
      await redditClient.downvoteSubmission(submissionModel.id);
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> clearVote(Submission submissionModel) async {
    try {
      await redditClient.removeVoteSubmission(submissionModel.id);
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> upvote(Submission submissionModel) async {
    try {
      await redditClient.upvoteSubmission(submissionModel.id);

      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<List<RedditLink>> _hot(
      String subreddit, TimeFilter filter, String after) async {
    final linksAsJson = await redditClient.hotSubmissions(subreddit, after);

    return linksAsJson.map((link) => RedditLink.fromJson(link)).toList();
  }

  Future<List<RedditLink>> _newest(
      String subreddit, TimeFilter filter, String after) async {
    final List<Map<dynamic, dynamic>> linksAsJson =
        await redditClient.newestSubmissions(subreddit, after);
    return linksAsJson.map((link) => RedditLink.fromJson(link)).toList();
  }

  Future<List<RedditLink>> _rising(String subreddit, String after) async {
    final List<Map<dynamic, dynamic>> linksAsJson =
        await redditClient.risingSubmissions(subreddit, after);
    return linksAsJson.map((link) => RedditLink.fromJson(link)).toList();
  }

  Future<List<RedditLink>> _controversial(
      String subreddit, String after, TimeFilter filter) async {
    final List<Map<dynamic, dynamic>> linksAsJson =
        await redditClient.controversialSubmissions(subreddit, after, filter);
    return linksAsJson.map((link) => RedditLink.fromJson(link)).toList();
  }

  Future<List<RedditLink>> _top(
      String subreddit, String after, TimeFilter filter) async {
    final List<Map<dynamic, dynamic>> linksAsJson =
        await redditClient.topSubmissions(subreddit, after, filter);
    return linksAsJson.map((link) => RedditLink.fromJson(link)).toList();
  }

  Future<Either<Failure, List<RedditLink>>> getRedditLinks(String subreddit,
      {String after,
      SubmissionSortType sort = SubmissionSortType.hot,
      TimeFilter filter = TimeFilter.all}) async {
    try {
      List<RedditLink> response;
      if (sort == SubmissionSortType.hot) {
        response = await _hot(subreddit, filter, after);
      } else if (sort == SubmissionSortType.newest) {
        response = await _newest(subreddit, filter, after);
      } else if (sort == SubmissionSortType.rising) {
        response = await _rising(subreddit, after);
      } else if (sort == SubmissionSortType.controversial) {
        response = await _controversial(subreddit, after, filter);
      } else if (sort == SubmissionSortType.top) {
        response = await _top(subreddit, after, filter);
      } else {
        throw Exception('Unknown SubmissionSortType $sort');
      }
      return Right(response);
    } catch (e) {
      print('failed in redditSerivce -- ${e.toString()}');
      return Left(SomeFailure(message: e.toString()));
    }
  }

  List<String> _scopes = [
    'identity',
    'edit',
    'flair',
    'history',
    'modconfig',
    'modflair',
    'modlog',
    'modposts',
    'modwiki',
    'mysubreddits',
    'privatemessages',
    'read',
    'report',
    'save',
    'submit',
    'subscribe',
    'vote'
  ];

  Future<AuthUser> loginWithNewAccount() async {
    return redditClient.loginWithNewAccount(_scopes, _state);
  }

  initializeWithoutAuth() async {
    await redditClient.initializeWithoutAuth();
  }

  String initializeWithAuth(String token) {
    return redditClient.initializeWithAuth(token);
  }
}
