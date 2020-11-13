import 'package:drago/common/common.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';

class MediaViewerBottomRow extends StatelessWidget {
  final Submission submission;
  final Bloc bloc;

  MediaViewerBottomRow({
    @required this.submission,
    this.bloc,
  })  : assert(submission != null),
        assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[_votesAndScore(context, submission)],
    );
  }

  Widget _votesAndScore(context, Submission submission) {
    return Row(
      children: [
        SquareActionButton(
          activeBackgroundColor: CupertinoColors.activeOrange,
          iconData: CupertinoIcons.arrow_up,
          onTap: () => bloc.add(Upvote()),
          switchCondition: submission.voteState == VoteState.Up,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(submission.score.toString(),
              style: TextStyle(color: CupertinoColors.lightBackgroundGray)),
        ),
        SquareActionButton(
          activeBackgroundColor: CupertinoColors.systemPurple,
          iconData: CupertinoIcons.arrow_down,
          onTap: () => bloc.add(Downvote()),
          switchCondition: submission.voteState == VoteState.Down,
        )
      ],
    );
  }
}
