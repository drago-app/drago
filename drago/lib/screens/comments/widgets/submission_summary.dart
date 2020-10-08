import 'package:drago/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SubmissionSummary extends StatelessWidget {
  final String subreddit;
  final AuthorViewModel authorViewModel;
  final ScoreViewModel scoreViewModel;
  final Function onSubredditTapped;

  const SubmissionSummary(
      {this.subreddit,
      this.authorViewModel,
      this.scoreViewModel,
      this.onSubredditTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoTheme.of(context).barBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(
                text: 'in ',
                style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 14,
                    letterSpacing: 0,
                    color: Colors.grey[700].withOpacity(.9)),
                children: [
                  TextSpan(
                    text: '$subreddit',
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: Colors.grey[700].withOpacity(.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => onSubredditTapped(context),
                  ),
                  TextSpan(text: ' by '),
                  TextSpan(
                      text: '${authorViewModel.name}',
                      style: DefaultTextStyle.of(context).style.copyWith(
                            color: authorViewModel.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => authorViewModel.onTap(context)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                ScoreWidget(scoreViewModel)
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: SubmissionRatio(submission: submission),
                // ),
                // SubmissionAge(
                //   age: submission.age,
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
