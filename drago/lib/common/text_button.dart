import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

class AuthorViewModel {
  final Author author;
  final Function onTap;
  String get name => author.name;
  Color get color => _mapTypeToColor(author.type);

  AuthorViewModel({@required this.author, this.onTap}) : assert(author != null);

  static Color _mapTypeToColor(AuthorType type) {
    if (type == AuthorType.admin) {
      return CupertinoColors.systemRed;
    } else if (type == AuthorType.moderator) {
      return CupertinoColors.systemGreen;
    } else if (type == AuthorType.developer) {
      return CupertinoColors.systemOrange;
    } else {
      return Colors.grey[600];
    }
  }
}

class AuthorWidget extends StatelessWidget {
  final AuthorViewModel author;

  AuthorWidget(this.author) : assert(author != null);

  @override
  Widget build(BuildContext context) {
    return TextButton(author.name,
        onTap: author.onTap,
        style: TextButton.defaultTextStyle.copyWith(
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: author.color));
  }
}
