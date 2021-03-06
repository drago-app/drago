import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:drago/core/entities/submission_author.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final TextStyle style;
  static TextStyle defaultTextStyle = const TextStyle();

  TextButton(this.text, {this.onTap, this.style}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style ?? defaultTextStyle,
      ),
    );
  }
}

enum AuthorTextButtonSize { small, medium, large }

class AuthorTextButton extends StatelessWidget {
  final SubmissionAuthor author;
  final AuthorTextButtonSize size;
  final Function onTap;

  AuthorTextButton(
      {@required this.author,
      @required this.onTap,
      this.size = AuthorTextButtonSize.small})
      : assert(author != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return TextButton(author.name,
        onTap: onTap,
        style: TextButton.defaultTextStyle.copyWith(
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
            fontSize: _size(size),
            color: _mapTypeToColor(author.type)));
  }

  static Color _mapTypeToColor(AuthorType type) {
    if (type == AuthorType.Admin) {
      return CupertinoColors.systemRed;
    } else if (type == AuthorType.Moderator) {
      return CupertinoColors.systemGreen;
    } else if (type == AuthorType.Special) {
      return CupertinoColors.systemPink;
    } else {
      return Colors.grey[600];
    }
  }

  static double _size(AuthorTextButtonSize size) {
    switch (size) {
      case AuthorTextButtonSize.small:
        return 13;
      case AuthorTextButtonSize.medium:
        return 15;
      case AuthorTextButtonSize.large:
      default:
        return 13;
    }
  }
}
