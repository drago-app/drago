import 'package:flutter/cupertino.dart';

class SubmissionAge extends StatelessWidget {
  final String age;

  SubmissionAge({@required this.age});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.clock,
            size: 12,
          ),
          Text(
            age,
            style: TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}
