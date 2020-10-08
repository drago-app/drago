import 'package:drago/common/common.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubmissionActions extends StatelessWidget {
  final Function onUpVote;
  final Function onDownVote;
  final Function onSave;
  final VoteState voteState;
  final bool saved;

  const SubmissionActions(
      {this.onUpVote,
      this.onDownVote,
      this.onSave,
      this.saved,
      this.voteState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        border: Border(
          top: BorderSide(width: 0, color: CupertinoColors.separator),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SquareActionButton(
            color: CupertinoColors.activeOrange,
            iconData: FontAwesomeIcons.longArrowAltUp,
            onTap: () => onUpVote(),
            switchCondition: voteState == VoteState.Up,
          ),
          SquareActionButton(
            color: CupertinoColors.systemPurple,
            iconData: FontAwesomeIcons.longArrowAltDown,
            onTap: () => onDownVote(),
            switchCondition: voteState == VoteState.Down,
          ),
          SquareActionButton(
            color: CupertinoColors.activeGreen,
            iconData: FontAwesomeIcons.bookmark,
            onTap: () => onSave(),
            switchCondition: saved == true,
          ),
          SquareActionButton(
            color: CupertinoColors.activeBlue,
            iconData: FontAwesomeIcons.reply,
            onTap: () => null,
            switchCondition: false,
          ),
          SquareActionButton(
            color: CupertinoColors.activeBlue,
            iconData: FontAwesomeIcons.shareSquare,
            onTap: () => null,
            switchCondition: false,
          ),
        ],
      ),
    );
  }
}
