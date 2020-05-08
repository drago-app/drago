import 'package:flutter/cupertino.dart';

class SubmissionNumComments extends StatelessWidget {
  final int numComments;
  SubmissionNumComments({@required this.numComments});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.conversation_bubble,
            size: 12,
          ),
          Text(
            numComments.toString(),
            style: TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}
