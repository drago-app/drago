// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:drago/features/submission/usecases.dart';
import 'package:drago/reddit_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DownvoteOrClear downvoteOrClear;
  RedditService redditService;

  setUp() {
    redditService = RedditService();
  }

  test(
      'Given a submission, when the user is not authenticated, then it returns a NotAuthorized failure',
      () {});
}
