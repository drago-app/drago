import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_submissions.dart';

class SubmissionScore extends StatelessWidget {
  final Submission submission;
  final Function onTap;

  SubmissionScore({@required this.submission, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // FaIcon(FontAwesomeIcons.arrowUp,
            //     size: 14, color: _mapStateToColor(submission.voteState)),
            // Text(
            //   ' ${submission.score.asString}',
            //   style: TextStyle(
            //       fontSize: 14, color: _mapStateToColor(submission.voteState)),
            // )
          ],
        ));
  }

  Color _mapStateToColor(VoteState_ state) {
    if (state == VoteState_.Up) {
      return CupertinoColors.activeOrange;
    } else if (state == VoteState_.Down) {
      return CupertinoColors.systemPurple;
    } else {
      return CupertinoColors.darkBackgroundGray.withOpacity(.7);
    }
  }
}
