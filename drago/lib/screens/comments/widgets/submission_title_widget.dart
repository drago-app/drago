

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SubmissionTitleWidget extends StatelessWidget {
  final String title;

  const SubmissionTitleWidget(this.title, {Key? key})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
