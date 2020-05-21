import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:drago/models/sort_option.dart';
import 'package:draw/draw.dart';
import 'package:drago/core/entities/preview.dart';
import 'package:drago/core/entities/submission_author.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/models/reddit_user.dart';
import 'package:drago/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dcache/dcache.dart';

import 'models/comment_model.dart';
import 'models/num_comments_model.dart';
import 'models/score_model.dart';
import 'user_service.dart';

class RedditService {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  Reddit _reddit;
  String _state = 'thisisarandomstring';
  Cache submissions = new SimpleCache(storage: new SimpleStorage(size: 20));

  Future<List> getMoreComments(MoreCommentsModel moreComments) async {
    var targetSubId = moreComments.submissionId;
    var fromCache = submissions.get(targetSubId);
    if (fromCache == null) {
      final submission =
          await SubmissionRef.withID(_reddit, targetSubId).populate();
      fromCache = submission;
      submissions.set(fromCache.id, fromCache);
    }
    ListQueue nodes = ListQueue();
    fromCache.comments.comments.forEach((c) => nodes.add(c));
    while (nodes.isNotEmpty) {
      var n = nodes.removeFirst();
      if (n is MoreComments) {
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

  Future<List<BaseCommentModel>> getComments(SubmissionModel submission) async {
    final sub = await _reddit.submission(id: submission.id).populate();
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

  Future<Either<Failure, SubmissionModel>> saveSubmission(
      SubmissionModel submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      submission.save();
      return Right(_mapSubmissionToModel(submission));
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, SubmissionModel>> unsaveSubmission(
      SubmissionModel submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      submission.unsave();
      return Right(_mapSubmissionToModel(submission));
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> downvote(
      SubmissionModel submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.downvote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> clearVote(
      SubmissionModel submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.clearVote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  Future<Either<Failure, Unit>> upvote(SubmissionModel submissionModel) async {
    try {
      final submission =
          await _reddit.submission(id: submissionModel.id).populate();
      await submission.upvote();
      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e));
    }
  }

  VoteState_ _mapVoteState(VoteState state) {
    if (state == VoteState.upvoted) {
      return VoteState_.Up;
    } else if (state == VoteState.downvoted) {
      return VoteState_.Down;
    } else {
      return VoteState_.Neutral;
    }
  }

  TimeFilter _mapTimeFilter(TimeFilter_ filter) {
    if (filter == TimeFilter_.all) {
      return TimeFilter.all;
    } else if (filter == TimeFilter_.day) {
      return TimeFilter.day;
    } else if (filter == TimeFilter_.hour) {
      return TimeFilter.hour;
    } else if (filter == TimeFilter_.month) {
      return TimeFilter.month;
    } else if (filter == TimeFilter_.week) {
      return TimeFilter.week;
    } else {
      return TimeFilter.year;
    }
  }

  SubmissionModel _mapSubmissionToModel(Submission s) => SubmissionModel(
      id: s.id,
      subredditName: s.subreddit.displayName,
      title: s.title,
      author: SubmissionAuthor.factory(submission: s),
      upvotes: s.upvotes,
      authorFlairText: s.authorFlairText,
      score: ScoreModel(score: s.score),
      saved: s.saved,
      numComments: NumCommentsModel(numComments: s.numComments),
      upvoteRatio: doubleToString(s.upvoteRatio),
      age: createdUtcToAge(s.createdUtc),
      preview: ContentPreview.factory(submission: s),
      voteState: _mapVoteState(s.vote));

  Future<List<SubmissionModel>> _hot(
          String subreddit, Map<String, String> params) async =>
      await _reddit
          .subreddit(subreddit)
          .hot(params: params)
          .map((s) => s as Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<List<SubmissionModel>> _newest(
          String subreddit, Map<String, String> params) async =>
      await _reddit
          .subreddit(subreddit)
          .newest(params: params)
          .map((s) => s as Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();
  Future<List<SubmissionModel>> _rising(
          String subreddit, Map<String, String> params) async =>
      await _reddit
          .subreddit(subreddit)
          .rising(params: params)
          .map((s) => s as Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<List<SubmissionModel>> _controversial(String subreddit,
          Map<String, String> params, TimeFilter_ filter) async =>
      await _reddit
          .subreddit(subreddit)
          .controversial(params: params, timeFilter: _mapTimeFilter(filter))
          .map((s) => s as Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<List<SubmissionModel>> _top(String subreddit,
          Map<String, String> params, TimeFilter_ filter) async =>
      await _reddit
          .subreddit(subreddit)
          .top(params: params, timeFilter: _mapTimeFilter(filter))
          .map((s) => s as Submission)
          .map((s) => _mapSubmissionToModel(s))
          .toList();

  Future<Either<Failure, List<SubmissionModel>>> getSubmissions(
      String subreddit,
      {String after,
      SubmissionSortType sort = SubmissionSortType.hot,
      TimeFilter_ filter = TimeFilter_.all}) async {
    var params = Map<String, String>();
    params['limit'] = '15';
    params['after'] = after;

    try {
      List<SubmissionModel> response;
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
        throw Exception('Unknow SubmissionSortType $sort');
      }
      return Right(response);
    } catch (e) {
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
    /* //TODO
     Currently this allows the user to log in with one account. 
     Apollo is somehow able to maintain credentials for multiple accounts
     */

    Stream<String> onCode = await _server();
    _reddit = Reddit.createWebFlowInstance(
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

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // await prefs.setString(
    //     'reddit_auth_token', _reddit.auth.credentials.toJson());

    // debugPrint(_reddit.auth.credentials.toJson());
    Redditor me = await _reddit.user.me();
    // return RedditUser(
    //     displayName: me.displayName,
    //     createdOn: me.createdUtc,
    //     commentKarma: me.commentKarma,
    //     postKarma: me.linkKarma);
    return AuthUser(
        name: me.displayName, token: _reddit.auth.credentials.toJson());
  }

  initializeWithoutAuth() async {
    _reddit = await Reddit.createUntrustedReadOnlyInstance(
      userAgent: userAgent,
      clientId: _identifier,
      deviceId: _deviceID,
    );
  }

  String initializeWithAuth(String token) {
    _reddit = Reddit.restoreAuthenticatedInstance(
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
