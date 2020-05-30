// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:drago/core/entities/submission_author.dart';

// class AuthorWidget extends StatelessWidget {
//   final SubmissionAuthor author;
//   final VoidCallback onTap;

//   AuthorWidget({@required this.author, @required this.onTap})
//       : assert(author != null),
//         assert(onTap != null);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: this.onTap,
//       child: Text(
//         author.name,
//         style: TextStyle(
//           color: _mapTypeToColor(author.type),
//           fontSize: 14,
//           fontStyle: FontStyle.normal,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Color _mapTypeToColor(AuthorType type) {
//     if (type == AuthorType.Admin) {
//       return CupertinoColors.destructiveRed;
//     } else if (type == AuthorType.Moderator) {
//       return CupertinoColors.activeGreen;
//     } else if (type == AuthorType.Special) {
//       return CupertinoColors.systemPink;
//     } else {
//       return CupertinoColors.darkBackgroundGray;
//     }
//   }
// }
