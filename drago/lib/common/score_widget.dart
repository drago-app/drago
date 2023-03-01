

import 'package:drago/common/common.dart';
import 'package:drago/models/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:drago/core/entities/vote_state.dart';

class ScoreViewModel {
  final Function? onTap;
  final VoteState? voteState;
  final ScoreModel? score;

  ScoreViewModel({this.onTap, required this.voteState, required this.score});
  Color get color => _mapStateToColor(voteState);

  Color _mapStateToColor(VoteState? state) {
    if (state == VoteState.Up) {
      return CupertinoColors.activeOrange;
    } else if (state == VoteState.Down) {
      return CupertinoColors.systemPurple;
    } else {
      return CupertinoColors.darkBackgroundGray.withOpacity(.7);
    }
  }
}

class ScoreWidgetSpan extends TappableIconTextSpan {
  final ScoreViewModel score;

  static final _iconWithColor =
      (color) => Icon(CupertinoIcons.arrow_up, size: 14, color: color);

  ScoreWidgetSpan(this.score)
      : assert(score != null),
        super(
            text: score.score.toString(),
            icon: _iconWithColor(score.color),
            style: TextStyle(color: score.color));

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
