import 'package:drago/models/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_submissions.dart';

class ScoreViewModel {
  final Function onTap;
  final VoteState voteState;
  final ScoreModel score;

  ScoreViewModel({this.onTap, @required this.voteState, @required this.score});
  Color get color => _mapStateToColor(voteState);

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

class ScoreWidget extends StatelessWidget {
  final ScoreViewModel score;

  ScoreWidget(this.score) : assert(score != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => score.onTap(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.arrowUp, size: 14, color: score.color),
            Text(
              ' ${score.score.toString()}',
              style: TextStyle(fontSize: 14, color: score.color),
            )
          ],
        ));
  }
}
