import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:drago/draw_reddit_adapter.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/types.dart';
import 'package:draw/draw.dart' as draw;
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'user_service.dart';

class RedditService {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  draw.Reddit _reddit;
  final RedditClient redditClient;
  String _state = 'thisisarandomstring';
  final userAgent = 'ios:com.example.helios:v0.0.1 (by /u/pinkywrinkle)';

  RedditService({@required this.redditClient});

  Future<List<Either>> getMoreComments(Map data, String submissionId) async {
    final List<dynamic> drawMoreOrComments =
        await draw.MoreComments.parse(_reddit, data, submissionId: submissionId)
            .comments();
    return _buildChildren(drawMoreOrComments);
  }

  Future<List<Either>> getComments(String submissionId) async {
    final sub = await _reddit.submission(id: submissionId).populate();

    final drawMoreOrComments = sub.comments.comments;

    return _buildChildren(drawMoreOrComments);
  }

  RedditComment _mapDrawCommentToRedditComment(draw.Comment c) {
    return RedditComment(
        author: c.author,
        body: c.body,
        id: c.id,
        score: c.score,
        voteState: _mapVoteState(c.vote),
        depth: c.depth,
        distinguished: c.data['distinguished'],
        authorFlairText: c.authorFlairText,
        createdUtc: c.createdUtc,
        edited: c.edited,
        children: (c.replies?.comments != null)
            ? _buildChildren(c.replies.comments)
            : []);
  }

  List<Either<More, RedditComment>> _buildChildren(List children) {
    if (children == null) return [];
    return children
        .map<Either>((moc) =>
            (moc is draw.MoreComments) ? Left(moc) : Right(moc as draw.Comment))
        .map<Either<More, RedditComment>>((moc) => moc.fold((more) {
              more as draw.MoreComments;
              return Left(More(
                  data: more.data,
                  count: more.count,
                  id: more.id,
                  parentId: more.parentId,
                  depth: more.data['depth'],
                  submissionId: null));
            },
                (comment) => Right(
                    _mapDrawCommentToRedditComment(comment as draw.Comment))))
        .toList();
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

  Future<Either<Failure, RedditLink>> saveSubmission(
      Submission submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      submission.save();
      return Right(_mapSubmissionToModel(submission));
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, RedditLink>> unsaveSubmission(
      Submission submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      submission.unsave();
      return Right(_mapSubmissionToModel(submission));
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> downvote(Submission submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.downvote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> clearVote(Submission submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.clearVote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> upvote(Submission submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.upvote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  VoteState _mapVoteState(draw.VoteState state) {
    if (state == draw.VoteState.upvoted) {
      return VoteState.Up;
    } else if (state == draw.VoteState.downvoted) {
      return VoteState.Down;
    } else {
      return VoteState.Neutral;
    }
  }

  draw.TimeFilter _mapTimeFilter(TimeFilter_ filter) {
    if (filter == TimeFilter_.all) {
      return draw.TimeFilter.all;
    } else if (filter == TimeFilter_.day) {
      return draw.TimeFilter.day;
    } else if (filter == TimeFilter_.hour) {
      return draw.TimeFilter.hour;
    } else if (filter == TimeFilter_.month) {
      return draw.TimeFilter.month;
    } else if (filter == TimeFilter_.week) {
      return draw.TimeFilter.week;
    } else {
      return draw.TimeFilter.year;
    }
  }

  RedditLink _mapSubmissionToModel(draw.Submission s) {
    final r = RedditLink(
      isNSFW: s.over18,
      author: s.author,
      createdUtc: s.createdUtc,
      edited: s.edited,
      isSelf: s.isSelf,
      stickied: s.stickied,
      domain: s.domain,
      distinguished: s.distinguished,
      voteState: _mapVoteState(s.vote),
      body: s.selftext,
      id: s.id,
      saved: s.saved,
      numComments: s.numComments,
      score: s.score,
      title: s.title,
      url: s.url.toString(),
      previewUrl: (s.preview.isEmpty)
          ? null
          : s.preview?.first?.source?.url?.toString(),
      subreddit: s.subreddit.displayName,
      authorFlairText: s.authorFlairText ?? '',
      linkFlairText: s.linkFlairText ?? '',
    );

    return r;
  }

  Future<List<RedditLink>> _hot(
      String subreddit, Map<String, String> params) async {
    final List<RedditLink> t = await _reddit
        .subreddit(subreddit)
        .hot(after: params['after'], params: params)
        .map((s) => s as draw.Submission)
        .map((s) => _mapSubmissionToModel(s))
        .toList();
    return t;
  }

  Future<List<RedditLink>> _newest(
          String subreddit, Map<String, String> params) async =>
      await _reddit
          .subreddit(subreddit)
          .newest(params: params)
          .map((s) => s as draw.Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();
  Future<List<RedditLink>> _rising(
          String subreddit, Map<String, String> params) async =>
      await _reddit
          .subreddit(subreddit)
          .rising(params: params)
          .map((s) => s as draw.Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<List<RedditLink>> _controversial(
      String subreddit, Map<String, String> params, TimeFilter_ filter) async {
    final List<RedditLink> t = await _reddit
        .subreddit(subreddit)
        .controversial(params: params, timeFilter: _mapTimeFilter(filter))
        .map((s) => s as draw.Submission)
        .map((s) => _mapSubmissionToModel(s))
        .toList();

    return t;
  }

  Future<List<RedditLink>> _top(String subreddit, Map<String, String> params,
          TimeFilter_ filter) async =>
      await _reddit
          .subreddit(subreddit)
          .top(params: params, timeFilter: _mapTimeFilter(filter))
          .map((s) => s as draw.Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<Either<Failure, List<RedditLink>>> getRedditLinks(String subreddit,
      {String after,
      SubmissionSortType sort = SubmissionSortType.hot,
      TimeFilter_ filter = TimeFilter_.all}) async {
    var params = Map<String, String>();
    params['limit'] = '25';
    params['after'] = (after == null) ? null : 't3_$after';

    try {
      List<RedditLink> response;
      if (sort == SubmissionSortType.hot) {
        response = await _hot(subreddit, params);
      } else if (sort == SubmissionSortType.newest) {
        response = await _newest(subreddit, params);
      } else if (sort == SubmissionSortType.rising) {
        response = await _rising(subreddit, params);
      } else if (sort == SubmissionSortType.controversial) {
        response = await _controversial(subreddit, params, filter);
      } else if (sort == SubmissionSortType.top) {
        response = await _top(subreddit, params, filter);
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
