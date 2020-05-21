import 'package:flutter/cupertino.dart';

class SubmissionAge extends StatelessWidget {
  final String age;

  SubmissionAge({@required this.age});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          CupertinoIcons.clock,
          size: 14,
          color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
        ),
        Text(
          age,
          style: TextStyle(
            color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}
