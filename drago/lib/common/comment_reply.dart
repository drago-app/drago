// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// /* What if I *rewrote* the markdown repo and instead of removing the tags (*, ~, etc) I left them in
// */

// class CommentReply extends StatefulWidget {
//   @override
//   _CommentReplyState createState() => _CommentReplyState();
// }

// class _CommentReplyState extends State<CommentReply> {
//   TextEditingController _controller =
//       TextEditingController(text: 'fj laksdjhf kajdhsf kljahdsf dsl');

//   @override
//   Widget build(BuildContext context) {
//     _controller.addListener(() => {print(_controller.text), setState(() {})});
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         backgroundColor: CupertinoColors.destructiveRed,
//         leading: GestureDetector(
//           onTap: () => _cancel(),
//           child: Text(
//             'Cancel',
//             style: CupertinoTheme.of(context).textTheme.actionTextStyle,
//           ),
//         ),
//       ),
//       child: Center(
//         child: Markdown(
//           styleSheet:
//               MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
//           onTapLink: (_) => null,
//           data: _controller.text,
//         ),
//       ),
//     );
//   }

//   _cancel() {
//     Navigator.of(context).pop();
//   }
// }
