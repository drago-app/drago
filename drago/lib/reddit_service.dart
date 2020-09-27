import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/types.dart';
import 'package:draw/draw.dart' as draw;
import 'package:drago/core/entities/preview.dart';
import 'package:drago/core/entities/submission_author.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dcache/dcache.dart';

import 'models/comment_model.dart';
import 'models/num_comments_model.dart';
import 'models/score_model.dart';
import 'user_service.dart';

class RedditService {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  draw.Reddit _reddit;
  String _state = 'thisisarandomstring';
  Cache submissions = new SimpleCache(storage: new SimpleStorage(size: 20));

  Future<List> getMoreComments(MoreCommentsModel moreComments) async {
    var targetSubId = moreComments.submissionId;
    var fromCache = submissions.get(targetSubId);
    if (fromCache == null) {
      final submission =
          await draw.SubmissionRef.withID(_reddit, targetSubId).populate();
      fromCache = submission;
      submissions.set(fromCache.id, fromCache);
    }
    ListQueue nodes = ListQueue();
    fromCache.comments.comments.forEach((c) => nodes.add(c));
    while (nodes.isNotEmpty) {
      var n = nodes.removeFirst();
      if (n is draw.MoreComments) {
        if (n.id == moreComments.id) {
          await fromCache.comments.replaceMore(specificMoreComments: n);
          break;
        }
      } else {
        if (n.replies != null && n.replies.comments != null) {
          nodes.addAll(n.replies.comments);
        }
      }
    }
    submissions.set(targetSubId, fromCache);
    return fromCache.comments.comments
        .map((c) => BaseCommentModel.factory(c))
        .toList();
  }

  Future<List<BaseCommentModel>> getComments(String submissionId) async {
    final sub = await _reddit.submission(id: submissionId).populate();
    submissions.set(sub.id, sub);
    return sub.comments.comments
        .map((c) => BaseCommentModel.factory(c))
        .toList();
  }

  Future<Either<Failure, List<String>>> defaultSubreddits() async {
    try {
      final subs = await _reddit.subreddits.defaults().toList();
      return Right(subs.map((sub) => sub.displayName).toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(
          message: '[RedditService#defaultSubreddit] e.toString()'));
    }
  }

  Future<Either<Failure, List<String>>> subscriptions() async {
    try {
      final subs = await _reddit.user.subreddits().toList();
      return Right(subs.map((sub) => sub.displayName).toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<String>>> moderatedSubreddits() async {
    try {
      final subs = await _reddit.user.moderatorSubreddits().toList();
      return Right(subs.map((sub) => sub.displayName).toList()..sort());
    } catch (e) {
      return Left(SomeFailure(message: e));
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
      author: s.author,
      createdUtc: s.createdUtc,
      edited: s.edited,
      isSelf: s.isSelf,
      domain: s.domain,
      distinguished: s.distinguished,
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
  final userAgent = 'ios:com.example.helios:v0.0.1 (by /u/pinkywrinkle)';

  Future<AuthUser> loginWithNewAccount() async {
    Stream<String> onCode = await _server();
    _reddit = draw.Reddit.createWebFlowInstance(
      userAgent: userAgent,
      clientId: _identifier,
      clientSecret: _secret,
      redirectUri: Uri.parse('http://localhost:8080'),
    );

    final authUrl =
        _reddit.auth.url(_scopes, _state, compactLogin: true).toString();

    _launchURL(authUrl);

    final String code = await onCode.first;

    await _reddit.auth.authorize(code);

    draw.Redditor me = await _reddit.user.me();

    return AuthUser(
        name: me.displayName, token: _reddit.auth.credentials.toJson());
  }

  initializeWithoutAuth() async {
    _reddit = await draw.Reddit.createUntrustedReadOnlyInstance(
      userAgent: userAgent,
      clientId: _identifier,
      deviceId: _deviceID,
    );
  }

  String initializeWithAuth(String token) {
    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      token,
      userAgent: userAgent,
      redirectUri: Uri.parse('http://localhost:8080'),
      clientId: _identifier,
      clientSecret: _secret,
    );
    return _reddit.auth.credentials.toJson();
  }

  // Future<RedditUser> init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('reddit_auth_token');

  //   if (token == null) {
  //     _reddit = await Reddit.createUntrustedReadOnlyInstance(
  // userAgent: userAgent,
  // clientId: _identifier,
  // deviceId: _deviceID,
  //     );
  //     print('UNTRUSTEDREADONLYINSTANCE ${_reddit.toString()}');
  //     return RedditUser(
  //         displayName: '',
  //         postKarma: 0,
  //         commentKarma: 0,
  //         createdOn: DateTime.now());
  //   } else {
  // _reddit = Reddit.restoreAuthenticatedInstance(
  //   token,
  //   userAgent: userAgent,
  //   redirectUri: Uri.parse('http://localhost:8080'),
  //   clientId: _identifier,
  //   clientSecret: _secret,
  // );
  //     print('RESTOREAUTHENTICATEDINSTANCE ${_reddit.toString()}');
  //     final Redditor me = await _reddit.user.me(useCache: true);
  //     return RedditUser(
  //         displayName: me.displayName,
  //         createdOn: me.createdUtc,
  //         commentKarma: me.commentKarma,
  //         postKarma: me.linkKarma);
  //   }
  // }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();

    final HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write("<html><h1>You can now close this window</h1></html>");

      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });

    return onCode.stream;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
