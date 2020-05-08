import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helius/blocs/submission_bloc.dart/submission.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/screens/subreddit/widgets/widgets.dart';

class MediaViewerBottomRow extends StatelessWidget {
  final SubmissionModel submission;
  final Bloc bloc;

  MediaViewerBottomRow({
    @required this.submission,
    this.bloc,
  })  : assert(submission != null),
        assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[_votesAndScore(context, submission)],
    );
  }

  Widget _votesAndScore(context, submission) {
    return Row(
      children: [
        VoteButton(
          color: CupertinoColors.activeOrange,
          iconData: FontAwesomeIcons.longArrowAltUp,
          onTap: () => bloc.add(Upvote()),
          switchCondition: submission.voteState == VoteState_.Up,
        ),
        Text('${submission.score}'),
        VoteButton(
          color: CupertinoColors.systemPurple,
          iconData: FontAwesomeIcons.longArrowAltDown,
          onTap: () => bloc.add(Downvote()),
          switchCondition: submission.voteState == VoteState_.Down,
        )
      ],
    );
  }
}