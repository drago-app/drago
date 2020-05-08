// import 'package:draw/draw.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:helius/common/author_widget.dart';
// import 'package:helius/common/common.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:helius/common/custom_expansion_tile.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:url_launcher/url_launcher.dart';
// import './common.dart';

// class CommentWidget extends StatelessWidget {
//   final /*Comment*/ comment;
//   final Widget trailing;
//   final unescape = new HtmlUnescape();

//   CommentWidget({@required this.comment, this.trailing});

//   @override
//   Widget build(BuildContext context) {
//     return CustomExpansionTile(
//       backgroundColor: CupertinoTheme.of(context).primaryContrastingColor,
//       indentation: 4.0 * comment.depth,
//       trailing: trailing,
//       sideBorderColor: (comment.depth == 0)
//           ? Colors.transparent
//           : (comment.depth == 9) ? Colors.blue : Colors.red,
//       initiallyExpanded: true,
//       title: AuthorWidget(author: comment.author, onTap: () => null),
//       body: _body(context, comment),
//       children: (comment.replies == null)
//           ? []
//           : comment.replies.comments
//               .map<Widget>(
//                 (c) => Padding(
//                     padding: EdgeInsets.only(left: 0),
//                     child: _commentChild(c, comment)),
//               )
//               .toList(),
//     );
//   }

//   _commentChild(child, comment) {
//     if (child is Comment) {
//       return CommentWidget(
//         comment: child,
//       );
//     }
//     if (child is MoreComments) {
//       return MoreCommentsWidget(
//         child,
//         parent: comment,
//       );
//     }

//     print('comment --- how did I get here? ${child.runtimeType}');
//   }

//   Widget _body(BuildContext context, Comment comment) {
//     return MarkdownBody(
//       styleSheet:
//           MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
//       data: unescape.convert(comment.body),
//       onTapLink: (url) => _launchURL(url),
//     );
//   }

//   _launchURL(url) async {
//     // const url = 'https://flutter.io';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
