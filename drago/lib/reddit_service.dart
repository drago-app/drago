import 'dart:io';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:draw/draw.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/preview.dart';
import 'package:helius/core/entities/submission_author.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/core/error/failures.dart';
import 'package:helius/models/author_model.dart';
import 'package:helius/models/reddit_user.dart';
import 'package:helius/utils.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedditService {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  Reddit _reddit;
  String _state = 'thisisarandomstring';

  Future<Either<Failure, List<String>>> subscriptions() async {
    try {
      final subs = await _reddit.user.subreddits().toList();
      return Right(subs.map((sub) => sub.displayName).toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    } catch (e) {
      return Left(SomeFailure(message: e));
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

  Either<Failure, Unit> downvote(SubmissionModel submissionModel) {
    try {
      _reddit
          .submission(id: submissionModel.id)
          .populate()
          .then((submission) => submission.downvote(waitForResponse: false));

      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e.toString()));
    }
  }

  Either<Failure, Unit> clearVote(SubmissionModel submissionModel) {
    try {
      _reddit
          .submission(id: submissionModel.id)
          .populate()
          .then((submission) => submission.clearVote(waitForResponse: false));

      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e.toString()));
    }
  }

  Either<Failure, Unit> upvote(SubmissionModel submissionModel) {
    try {
      _reddit
          .submission(id: submissionModel.id)
          .populate()
          .then((submission) => submission.upvote(waitForResponse: false));

      return Right(unit);
    } catch (e) {
      return Left(SomeFailure(message: e.toString()));
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

  SubmissionModel _mapSubmissionToModel(Submission s) => SubmissionModel(
      id: s.id,
      title: s.title,
      author: SubmissionAuthor.factory(submission: s),
      authorFlairText: s.authorFlairText ?? '',
      upvotes: s.upvotes,
      score: s.score,
      saved: s.saved,
      numComments: s.numComments,
      age: createdUtcToAge(s.createdUtc),
      preview: ContentPreview.factory(submission: s),
      voteState: _mapVoteState(s.vote));

  Future<List> getSubmissions(String subreddit,
      {String after, String sort = 'hot'}) async {
    var params = Map<String, String>();
    params['limit'] = '15';
    params['after'] = after;
    switch (sort) {
      case 'hot':
        return await _reddit
            .subreddit(subreddit)
            .hot(params: params)
            .map((s) => s as Submission)
            .map((s) => _mapSubmissionToModel(s))
            .toList();
      case 'top':
        return await _reddit
            .subreddit(subreddit)
            .top(params: params)
            .map((s) => s as Submission)
            .map((s) => _mapSubmissionToModel(s))
            .toList();
      case 'newest':
        return await _reddit
            .subreddit(subreddit)
            .newest(params: params)
            .map((s) => s as Submission)
            .map((s) => _mapSubmissionToModel(s))
            .toList();
      default:
        return [];
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

  Future<RedditUser> loginWithNewAccount() async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'reddit_auth_token', _reddit.auth.credentials.toJson());

    // debugPrint(_reddit.auth.credentials.toJson());
    Redditor me = await _reddit.user.me();
    return RedditUser(
        displayName: me.displayName,
        createdOn: me.createdUtc,
        commentKarma: me.commentKarma,
        postKarma: me.linkKarma);
  }

  Future<RedditUser> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('reddit_auth_token');

    if (token == null) {
      _reddit = await Reddit.createUntrustedReadOnlyInstance(
        // final reddit = await Reddit.createUntrustedReadOnlyInstance(
        userAgent: userAgent,
        clientId: _identifier,
        deviceId: _deviceID,
      );
      print('UNTRUSTEDREADONLYINSTANCE ${_reddit.toString()}');
      return RedditUser(
          displayName: '',
          postKarma: 0,
          commentKarma: 0,
          createdOn: DateTime.now());
    } else {
      _reddit = Reddit.restoreAuthenticatedInstance(
        token,
        userAgent: userAgent,
        redirectUri: Uri.parse('http://localhost:8080'),
        clientId: _identifier,
        clientSecret: _secret,
      );
      print('RESTOREAUTHENTICATEDINSTANCE ${_reddit.toString()}');
      final Redditor me = await _reddit.user.me(useCache: true);
      return RedditUser(
          displayName: me.displayName,
          createdOn: me.createdUtc,
          commentKarma: me.commentKarma,
          postKarma: me.linkKarma);
    }
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();

    final HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
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
