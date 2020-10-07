import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/custom_expansion_tile.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import './common.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final Widget trailing;
  final unescape = new HtmlUnescape();

  CommentWidget({@required this.comment, this.trailing});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      indentation: 8.0 * comment.depth,
      trailingOpen: trailing,
      sideBorderColor: (comment.depth == 0)
          ? Colors.transparent
          : (comment.depth == 9) ? Colors.blue : Colors.red,
      initiallyExpanded: true,
      title: Text(
          '${comment.author}'), // AuthorWidget(author: comment.author, onTap: () => null),
      body: _body(context, comment),
      children: (comment.children == null)
          ? []
          : comment.children
              .map<Widget>(
                (c) => Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: _commentChild(c, comment)),
              )
              .toList(),
    );
  }

  _commentChild(child, comment) {
    if (child is CommentModel) {
      return CommentWidget(
        comment: child,
      );
    }
    if (child is MoreCommentsModel) {
      return MoreCommentsWidget(child);
    }
    if (child is ContinueThreadModel) {
      return ContinueThreadWidget(
        continueThread: child,
      );
    }

    print('comment --- how did I get here? ${child.runtimeType}');
  }

  Widget _body(BuildContext context, CommentModel comment) {
    return MarkdownBody(
      styleSheet: MarkdownTheme.of(context),
      data: unescape.convert(comment.body),
      onTapLink: (url) => _launchURL(url),
    );
  }

  _launchURL(url) async {
    // const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
