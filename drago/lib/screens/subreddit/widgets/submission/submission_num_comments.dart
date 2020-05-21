import 'package:drago/core/entities/submission_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubmissionNumComments extends StatelessWidget {
  final SubmissionModel submission;
  SubmissionNumComments({@required this.submission});

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
          '${submission.numComments.asString}',
          style: TextStyle(
            color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}
