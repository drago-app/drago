import 'package:drago/models/comment_model.dart';
import 'package:drago/screens/comments/comments_page.dart';
import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/custom_expansion_tile.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final AuthorViewModel authorViewModel;
  final ScoreViewModel scoreViewModel;
  final List<Widget> children;
  final List colors;

  final unescape = new HtmlUnescape();

  CommentWidget(
      {@required this.comment,
      this.children,
      @required this.colors,
      @required this.scoreViewModel,
      @required this.authorViewModel});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      indentation: 8.0 * comment.depth,
      trailingOpen: [
        Icon(
          CupertinoIcons.ellipsis,
          size: 18,
          color: CupertinoColors.systemGrey,
        ),
      ],
      trailingClosed: [
        FlairWidget(
          color: CupertinoColors.systemGrey2,
          style: TextStyle(color: CupertinoColors.systemGrey6, fontSize: 14),
          flairText: '${comment.count}',
        ),
        SizedBox(
          width: 8,
        ),
        Icon(
          CupertinoIcons.chevron_down,
          size: 14,
          color: CupertinoColors.systemGrey,
        )
      ],
      sideBorderColor:
          (comment.depth == 0) ? Colors.transparent : colors[comment.depth],
      initiallyExpanded: true,
      title: RichText(
        text: TextSpan(children: [
          WidgetSpan(
              child: AuthorWidget(authorViewModel,
                  style: TextStyle(fontSize: 14))),
          WidgetSpan(child: SizedBox(width: 8)),
          WidgetSpan(child: ScoreWidgetSpan(scoreViewModel))
        ]),
      ),
      body: _body(context, comment),
      children: (comment.children == null)
          ? []
          : children
              .map<Widget>(
                  (c) => Padding(padding: EdgeInsets.only(left: 0), child: c))
              .toList(),
    );
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
