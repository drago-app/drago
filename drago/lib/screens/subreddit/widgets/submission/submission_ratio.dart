import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubmissionRatio extends StatelessWidget {
  final Submission submission;

  SubmissionRatio({@required this.submission});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FaIcon(FontAwesomeIcons.smile,
            size: 14,
            color: CupertinoColors.darkBackgroundGray.withOpacity(.7)),
        Text(
          'fix me',
          // ' ${submission.upvoteRatio}',
          style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.darkBackgroundGray.withOpacity(.7)),
        )
      ],
    );
  }
}
