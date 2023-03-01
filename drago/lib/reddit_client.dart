

import 'dart:async';
import 'dart:io';

import 'package:drago/models/sort_option.dart';
import 'package:drago/user_service.dart';
import 'package:draw/draw.dart' as draw;
import 'package:url_launcher/url_launcher.dart';

import 'core/entities/subreddit.dart';

abstract class RedditClient {
  Future<void> initializeWithoutAuth();
  String initializeWithAuth(String? token);
  Future<AuthUser> loginWithNewAccount(List<String> scopes, String state);

  Future<List<Subreddit>> defaultSubreddits();
  Future<List<Subreddit>> subscriptions();
  Future<List<Subreddit>> moderatedSubreddits();

  Future<List<Map<dynamic, dynamic>>> hotSubmissions(
      String subreddit, String? after);
  Future<List<Map<dynamic, dynamic>>> newestSubmissions(
      String subreddit, String? after);
  Future<List<Map<dynamic, dynamic>>> risingSubmissions(
      String subreddit, String? after);
  Future<List<Map<dynamic, dynamic>>> controversialSubmissions(
      String subreddit, String? after, TimeFilter? filter);
  Future<List<Map<dynamic, dynamic>>> topSubmissions(
      String subreddit, String? after, TimeFilter? filter);

  Future<void> saveSubmission(String? submissionId);
  Future<void> unsaveSubmission(String? submissionId);

  Future<void> upvoteSubmission(String? submissionId);
  Future<void> downvoteSubmission(String? submissionId);
  Future<void> removeVoteSubmission(String? submissionId);

  Future<List<Map<dynamic, dynamic>>> getCommentsForSubmission(
      String submissionId);
  Future<List<Map<dynamic, dynamic>>> expandMoreComments(
      Map data, String submissionId);
}

class DrawRedditClient implements RedditClient {
  late draw.Reddit _reddit;
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  final userAgent = 'ios:com.example.helios:v0.0.1 (by /u/pinkywrinkle)';

  DrawRedditClient();

  @override
  Future<void> initializeWithoutAuth() async {
    _reddit = await draw.Reddit.createUntrustedReadOnlyInstance(
      userAgent: userAgent,
      clientId: _identifier,
      deviceId: _deviceID,
    );
  }

  @override
  String initializeWithAuth(String? token) {
    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      token!,
      userAgent: userAgent,
      redirectUri: Uri.parse('http://localhost:8080'),
      clientId: _identifier,
      clientSecret: _secret,
    );
    return _reddit.auth.credentials.toJson();
  }

  @override
  Future<AuthUser> loginWithNewAccount(
      List<String> scopes, String state) async {
    Stream<String?> onCode = await _server();
    _reddit = draw.Reddit.createWebFlowInstance(
      userAgent: userAgent,
      clientId: _identifier,
      clientSecret: _secret,
      redirectUri: Uri.parse('http://localhost:8080'),
    );

    final authUrl =
        _reddit.auth.url(scopes, state, compactLogin: true).toString();

    _launchURL(authUrl);

    final String code = (await onCode.first)!;

    await _reddit.auth.authorize(code);

    draw.Redditor me = await _reddit.user.me();

    return AuthUser(
        name: me.displayName, token: _reddit.auth.credentials.toJson());
  }

  Future<List<Subreddit>> _drawSubToSubreddit(
      Stream<draw.SubredditRef> refs) async {
    return refs
        .map((sub) => sub as draw.RedditBaseInitializedMixin)
        .map((sub) => Subreddit.fromJson(sub.data as Map<String?, dynamic>))
        .toList();
  }

  @override
  Future<List<Subreddit>> defaultSubreddits() async =>
      _drawSubToSubreddit(_reddit.subreddits.defaults());

  Future<List<Subreddit>> subscriptions() async =>
      _drawSubToSubreddit(_reddit.user.subreddits());

  Future<List<Subreddit>> moderatedSubreddits() async =>
      _drawSubToSubreddit(_reddit.user.moderatorSubreddits());

  @override
  Future<List<Map<dynamic, dynamic>>> hotSubmissions(
      String subreddit, String? after) async {
    return await _getSubmissions(
        _reddit.subreddit(subreddit).hot, subreddit, after);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> newestSubmissions(
      String subreddit, String? after) async {
    return await _getSubmissions(
        _reddit.subreddit(subreddit).newest, subreddit, after);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> risingSubmissions(
      String subreddit, String? after) async {
    return await _getSubmissions(
        _reddit.subreddit(subreddit).rising, subreddit, after);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> controversialSubmissions(
      String subreddit, String? after, TimeFilter? filter) async {
    return await _getSubmissions(
        _reddit.subreddit(subreddit).controversial, subreddit, after,
        filter: filter);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> topSubmissions(
      String subreddit, String? after, TimeFilter? filter) async {
    return await _getSubmissions(
        _reddit.subreddit(subreddit).controversial, subreddit, after,
        filter: filter);
  }

  Future<List<Map<dynamic, dynamic>>> _getSubmissions(
    Function drawMethod,
    String subreddit,
    String? after, {
    TimeFilter? filter,
  }) async {
    var params = Map<String, String?>();
    params['limit'] = '25';
    params['after'] = (after == null) ? null : 't3_$after';

    Stream<draw.UserContent> stream = (filter == null)
        ? await drawMethod(params: params)
        : drawMethod(params: params, timeFilter: _mapTimeFilter(filter));

    return stream
        .map((sub) => sub as draw.Submission)
        .map((sub) => sub.data)
        .toList();
  }

  @override
  Future<void> unsaveSubmission(String? submissionId) async {
    final submission = await _reddit.submission(id: submissionId!).populate();
    return submission.unsave();
  }

  @override
  Future<void> saveSubmission(String? submissionId) async {
    final submission = await _reddit.submission(id: submissionId!).populate();
    return submission.save();
  }

  @override
  Future<void> upvoteSubmission(String? submissionId) async {
    final submission = await _reddit.submission(id: submissionId!).populate();
    return submission.upvote();
  }

  @override
  Future<void> downvoteSubmission(String? submissionId) async {
    final submission = await _reddit.submission(id: submissionId!).populate();
    return submission.downvote();
  }

  @override
  Future<void> removeVoteSubmission(String? submissionId) async {
    final submission = await _reddit.submission(id: submissionId!).populate();
    return submission.clearVote();
  }

  @override
  Future<List<Map>> getCommentsForSubmission(String submissionId) async {
    final submission = await _reddit.submission(id: submissionId).populate();
    final List<Map> json = submission.comments.comments
        .map((c) => (c as draw.RedditBaseInitializedMixin).data)
        .map((data) =>
            {'data': data, 'kind': (data['count'] != null) ? 'more' : 't1'})
        .toList();

    return json;
  }

  @override
  Future<List<Map<dynamic, dynamic>>> expandMoreComments(
      Map data, String submissionId) async {
    final List<dynamic> drawMoreOrComments =
        await draw.MoreComments.parse(_reddit, data, submissionId: submissionId)
            .comments();

    return drawMoreOrComments
        .map((c) => (c as draw.RedditBaseInitializedMixin).data)
        .map((data) =>
            {'data': data, 'kind': (data['count'] != null) ? 'more' : 't1'})
        .toList();
  }
}

Future<Stream<String?>> _server() async {
  final StreamController<String?> onCode = new StreamController();

  final HttpServer server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  server.listen((HttpRequest request) async {
    final String? code = request.uri.queryParameters["code"];

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

draw.TimeFilter _mapTimeFilter(TimeFilter filter) {
  if (filter == TimeFilter.all) {
    return draw.TimeFilter.all;
  } else if (filter == TimeFilter.day) {
    return draw.TimeFilter.day;
  } else if (filter == TimeFilter.hour) {
    return draw.TimeFilter.hour;
  } else if (filter == TimeFilter.month) {
    return draw.TimeFilter.month;
  } else if (filter == TimeFilter.week) {
    return draw.TimeFilter.week;
  } else {
    return draw.TimeFilter.year;
  }
}
