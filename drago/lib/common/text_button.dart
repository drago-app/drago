

import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Function? onTap;
  final TextStyle? style;
  static TextStyle _defaultTextStyle = const TextStyle();

  TextButton(this.text, {this.onTap, this.style}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Text(
        text,
        style: _defaultTextStyle.merge(style),
      ),
    );
  }
}

class AuthorViewModel {
  final Author author;
  final Function? onTap;
  final Color? defaultColor;
  String? get name => author.name;
  Color? get color =>
      _mapTypeToColor(author.type, defaultColor ?? Colors.grey[600]);

  AuthorViewModel({required this.author, this.onTap, this.defaultColor})
      : assert(author != null);

  static Color? _mapTypeToColor(AuthorType type, Color? defaultColor) {
    if (type == AuthorType.admin) {
      return CupertinoColors.systemRed;
    } else if (type == AuthorType.moderator) {
      return CupertinoColors.systemGreen;
    } else if (type == AuthorType.developer) {
      return CupertinoColors.systemOrange;
    } else {
      return defaultColor;
    }
  }
}

class AuthorWidget extends StatelessWidget {
  final AuthorViewModel author;
  final TextStyle? style;
  static final _defaultTextStyle = TextStyle(
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  AuthorWidget(this.author, {this.style}) : assert(author != null);

  @override
  Widget build(BuildContext context) {
    return TextButton(author.name!,
        onTap: author.onTap,
        style: _defaultTextStyle
            .merge(TextStyle(color: author.color).merge(style ?? TextStyle())));
  }
}
