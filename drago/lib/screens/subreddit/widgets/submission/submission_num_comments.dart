import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/num_comments_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumCommentsViewModel {
  final NumComments _numComments;
  String get value => _numComments.toString();
  NumCommentsViewModel(this._numComments);
}

class NumCommentsWidget extends StatelessWidget {
  final NumCommentsViewModel numCommentsViewModel;
  NumCommentsWidget(this.numCommentsViewModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FaIcon(
          FontAwesomeIcons.comment,
          size: 14,
          color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
        ),
        Text(
          ' ${numCommentsViewModel.value}',
          style: TextStyle(
            color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}
