

import 'package:drago/common/common.dart';
import 'package:drago/core/entities/vote_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SubmissionActions extends StatelessWidget {
  final Function? onUpVote;
  final Function? onDownVote;
  final Function? onSave;
  final VoteState? voteState;
  final bool? saved;

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
            activeBackgroundColor: CupertinoColors.activeOrange,
            inActiveIconColor: CupertinoColors.systemBlue,
            iconData: CupertinoIcons.arrow_up,
            onTap: () => onUpVote!(),
            switchCondition: voteState == VoteState.Up,
          ),
          SquareActionButton(
            activeBackgroundColor: CupertinoColors.systemPurple,
            inActiveIconColor: CupertinoColors.systemBlue,
            iconData: CupertinoIcons.arrow_down,
            onTap: () => onDownVote!(),
            switchCondition: voteState == VoteState.Down,
          ),
          SquareActionButton(
            activeBackgroundColor: CupertinoColors.activeGreen,
            inActiveIconColor: CupertinoColors.systemBlue,
            iconData: CupertinoIcons.bookmark,
            onTap: () => onSave!(),
            switchCondition: saved == true,
          ),
          SquareActionButton(
            activeBackgroundColor: CupertinoColors.activeBlue,
            inActiveIconColor: CupertinoColors.systemBlue,
            iconData: CupertinoIcons.reply,
            onTap: () => null,
            switchCondition: false,
          ),
          SquareActionButton(
            activeBackgroundColor: CupertinoColors.activeBlue,
            inActiveIconColor: CupertinoColors.systemBlue,
            iconData: CupertinoIcons.square_arrow_up,
            onTap: () => null,
            switchCondition: false,
          ),
        ],
      ),
    );
  }
}
