import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:drago/core/entities/submission_author.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final TextStyle style;
  static TextStyle defaultTextStyle =
      const TextStyle(fontWeight: FontWeight.bold);

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

class AuthorTextButton extends StatelessWidget {
  final SubmissionAuthor author;
  final Function onTap;

  AuthorTextButton({@required this.author, @required this.onTap})
      : assert(author != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return TextButton(author.name,
        onTap: onTap,
        style: TextButton.defaultTextStyle
            .copyWith(color: _mapTypeToColor(author.type)));
  }

  static Color _mapTypeToColor(AuthorType type) {
    if (type == AuthorType.Admin) {
      return CupertinoColors.destructiveRed;
    } else if (type == AuthorType.Moderator) {
      return CupertinoColors.activeGreen;
    } else if (type == AuthorType.Special) {
      return CupertinoColors.systemPink;
    } else {
      return CupertinoColors.darkBackgroundGray;
    }
  }
}
