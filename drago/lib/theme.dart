

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

enum AppTheme { light, dark }
typedef Color();

final appThemeData = {
  AppTheme.light: CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.activeBlue,
      primaryContrastingColor: CupertinoColors.activeOrange,
      textTheme: CupertinoTextThemeData(
          textStyle: defaultTextStyle,
          actionTextStyle: null,
          tabLabelTextStyle: null,
          navTitleTextStyle: null,
          navLargeTitleTextStyle: null,
          navActionTextStyle: null,
          pickerTextStyle: null,
          dateTimePickerTextStyle: null),
      barBackgroundColor: null,
      scaffoldBackgroundColor: CupertinoColors.systemGrey6),
  AppTheme.dark: CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.activeBlue,
      primaryContrastingColor: CupertinoColors.activeOrange,
      textTheme: CupertinoTextThemeData(
          textStyle: defaultTextStyle,
          actionTextStyle: null,
          tabLabelTextStyle: null,
          navTitleTextStyle: null,
          navLargeTitleTextStyle: null,
          navActionTextStyle: null,
          pickerTextStyle: null,
          dateTimePickerTextStyle: null),
      barBackgroundColor: CupertinoColors.systemBackground,
      scaffoldBackgroundColor: CupertinoColors.systemGrey6)
};

const defaultTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 15.0,
  letterSpacing: -0.41,
  color: CupertinoColors.label,
  decoration: TextDecoration.none,
);

class MarkdownTheme {
  static of(context) =>
      md.MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context))
          .copyWith(
              blockSpacing: 14,
              blockquote: TextStyle(
                fontStyle: FontStyle.italic,
                color: CupertinoTheme.of(context).brightness == Brightness.dark
                    ? CupertinoColors.systemGrey.darkColor
                    : CupertinoColors.systemGrey.color,
              ),
              blockquotePadding: const EdgeInsets.symmetric(horizontal: 16),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        CupertinoTheme.of(context).brightness == Brightness.dark
                            ? CupertinoColors.systemGrey4.darkColor
                            : CupertinoColors.systemGrey4.color,
                    width: 2,
                  ),
                ),
              ));
}
