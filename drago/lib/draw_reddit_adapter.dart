import 'dart:async';
import 'dart:io';

import 'package:drago/user_service.dart';
import 'package:draw/draw.dart' as draw;
import 'package:url_launcher/url_launcher.dart';

abstract class RedditClient {
  Future<void> initializeWithoutAuth();
  String initializeWithAuth(String token);
  Future<AuthUser> loginWithNewAccount(List<String> scopes, String state);
  Future<List<String>> defaultSubreddits();
  Future<List<String>> subscriptions();
  Future<List<String>> moderatedSubreddits();
}

class DrawRedditClient implements RedditClient {
  draw.Reddit _reddit;
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop1';
  final userAgent = 'ios:com.example.helios:v0.0.1 (by /u/pinkywrinkle)';

  DrawRedditClient() {
    initializeWithoutAuth();
  }

  @override
  Future<void> initializeWithoutAuth() async {
    print('before initializeWithoutAuth -- _reddit is $_reddit');
    _reddit = await draw.Reddit.createUntrustedReadOnlyInstance(
      userAgent: userAgent,
      clientId: _identifier,
      deviceId: _deviceID,
    );
    print('after initializeWithoutAuth -- _reddit is $_reddit');
  }

  @override
  String initializeWithAuth(String token) {
    print('before initializeWithAuth -- _reddit is $_reddit');

    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      token,
      userAgent: userAgent,
      redirectUri: Uri.parse('http://localhost:8080'),
      clientId: _identifier,
      clientSecret: _secret,
    );
    print('after initializeWithAuth -- _reddit is $_reddit');
    return _reddit.auth.credentials.toJson();
  }

  @override
  Future<AuthUser> loginWithNewAccount(
      List<String> scopes, String state) async {
    Stream<String> onCode = await _server();
    _reddit = draw.Reddit.createWebFlowInstance(
      userAgent: userAgent,
      clientId: _identifier,
      clientSecret: _secret,
      redirectUri: Uri.parse('http://localhost:8080'),
    );

    final authUrl =
        _reddit.auth.url(scopes, state, compactLogin: true).toString();

    _launchURL(authUrl);

    final String code = await onCode.first;

    await _reddit.auth.authorize(code);

    draw.Redditor me = await _reddit.user.me();

    return AuthUser(
        name: me.displayName, token: _reddit.auth.credentials.toJson());
  }

  @override
  Future<List<String>> defaultSubreddits() async {
    final subredditRefs = await _reddit.subreddits.defaults().toList();
    return subredditRefs.map((ref) => ref.displayName).toList();
  }

  Future<List<String>> subscriptions() async {
    final subredditRefs = await _reddit.user.subreddits().toList();
    return subredditRefs.map((ref) => ref.displayName).toList();
  }

  Future<List<String>> moderatedSubreddits() async {
    final subredditRefs = await _reddit.user.moderatorSubreddits().toList();
    return subredditRefs.map((ref) => ref.displayName).toList();
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
