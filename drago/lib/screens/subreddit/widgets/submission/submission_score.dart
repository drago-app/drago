import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_reddit_links.dart';

class SubmissionScore extends StatelessWidget {
  final Submission submission;
  final GestureTapCallback? onTap;

  SubmissionScore({required this.submission, required this.onTap});

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

  Color _mapStateToColor(VoteState state) {
    if (state == VoteState.Up) {
      return CupertinoColors.activeOrange;
    } else if (state == VoteState.Down) {
      return CupertinoColors.systemPurple;
    } else {
      return CupertinoColors.darkBackgroundGray.withOpacity(.7);
    }
  }
}
