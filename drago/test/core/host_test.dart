// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:drago/sandbox/host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'given an imgur link for an album with one picture it should return one ImageMedia',
      () async {
    final imgurUrl = 'https://imgur.com/a/rW8YDJa';
    final expected = 'https://imgur.com/WEZNxoMm.jpg';

    final resultStream = Host.getMedia(imgurUrl);
    final result = await resultStream.first;

    expect((result as ImageMedia).src, expected);
  });
}
