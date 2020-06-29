import 'package:drago/common/comment.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/common/text_button.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/comments_page_bloc/comments_page.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';

import '../../theme.dart';
import 'widgets/submission/submission.dart';
import 'widgets/submission/submission_ratio.dart';
import 'widgets/submission/vote_button.dart';
import 'package:drago/features/subreddit/get_submissions.dart';

class SubmissionContentWidget extends StatelessWidget {
  final Submission submission;
  SubmissionContentWidget({@required this.submission});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    // if (submission.content is ImageSubmissionContent) {
    //   return MediaSubmissionWidget(
    //     mediaWidget: Picture(
    //       maxHeight: MediaQuery.of(context).size.height * .5,
    //       url: submission.content.content.url,
    //     ),
    //     titleWidget: SubmissionTitle(
    //       submission: submission,
    //     ),
    //   );
    // } else if (submission.content is GifSubmissionContent) {
    //   return MediaSubmissionWidget(
    //     titleWidget: SubmissionTitle(submission: submission),
    //     mediaWidget: Picture(
    //       maxHeight: MediaQuery.of(context).size.height * .5,
    //       url: submission.content.content.url,
    //     ),
    //   );
    // } else if (submission.content is SelfSubmissionContent) {
    //   return SelfOrLinkSubmissionWidget(
    //     titleWidget: SubmissionTitle(
    //       submission: submission,
    //     ),
    //     submissionWidget: md.MarkdownBody(
    //         data: submission.content.content,
    //         styleSheet: MarkdownTheme.of(context)),
    //   );
    // }
  }
}

class MediaSubmissionWidget extends StatelessWidget {
  final Widget mediaWidget;
  final Widget titleWidget;
  MediaSubmissionWidget(
      {@required this.mediaWidget, @required this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mediaWidget,
        Container(
            width: MediaQuery.of(context).size.width,
            color: CupertinoTheme.of(context).barBackgroundColor,
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: titleWidget),
      ],
    );
  }
}

class SelfOrLinkSubmissionWidget extends StatelessWidget {
  final Widget titleWidget;
  final Widget submissionWidget;

  const SelfOrLinkSubmissionWidget(
      {Key key, @required this.titleWidget, @required this.submissionWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          titleWidget,
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: submissionWidget,
          )
        ],
      ),
    );
  }
}

class SubmissionTitle extends StatelessWidget {
  final Submission submission;

  const SubmissionTitle({Key key, @required this.submission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      submission.title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class CommentsPage extends StatelessWidget {
  final SubmissionBloc submissionBloc;

  CommentsPage({@required this.submissionBloc})
      : assert(submissionBloc != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
        bloc: submissionBloc,
        builder: (context, submissionState) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle:
                  Text('${submissionState.submission.numComments} Comments'),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SubmissionContentWidget(
                          submission: submissionState.submission),
                      _SubmissionDetails(
                        bloc: submissionBloc,
                        submission: submissionState.submission,
                      ),
                      _comments()
                    ],
                  )),
            ),
          );
        });
  }

  Widget _comments() {
    return BlocBuilder<CommentsPageBloc, CommentsPageState>(
        builder: (context, commentsState) {
      if (commentsState is CommentsLoaded) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: commentsState.comments.length,
          itemBuilder: (BuildContext context, int index) {
            return (commentsState.comments[index] is CommentModel)
                ? CommentWidget(comment: commentsState.comments[index])
                : MoreCommentsWidget(commentsState.comments[index]);
          },
        );
      } else {
        return Center(child: LoadingIndicator());
      }
    });
  }
}

class _SubmissionDetails extends StatelessWidget {
  final Submission submission;
  final SubmissionBloc bloc;

  const _SubmissionDetails({this.submission, this.bloc});

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
                    text: '${submission.subreddit}',
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: Colors.grey[700].withOpacity(.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).pushNamed(
                          '/subreddit',
                          arguments: submission.subreddit),
                  ),
                  TextSpan(text: ' by '),
                  TextSpan(
                    text: '${submission.author.name}',
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: Colors.grey[700].withOpacity(.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                // SubmissionScore(
                //   onTap: () => bloc.add(Upvote()),
                //   submission: submission,
                // ),
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
          _SubmissionActions(bloc: bloc, submission: submission)
        ],
      ),
    );
  }
}

class _SubmissionActions extends StatelessWidget {
  final Submission submission;
  final SubmissionBloc bloc;

  const _SubmissionActions({this.submission, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // color: CupertinoColors.systemIndigo,
        border: Border(
          top: BorderSide(width: 0, color: CupertinoColors.separator),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SquareActionButton(
          //   color: CupertinoColors.activeOrange,
          //   iconData: FontAwesomeIcons.longArrowAltUp,
          //   onTap: () => bloc.add(Upvote()),
          //   switchCondition: bloc.state.submission.voteState == VoteState_.Up,
          // ),
          // SquareActionButton(
          //   color: CupertinoColors.systemPurple,
          //   iconData: FontAwesomeIcons.longArrowAltDown,
          //   onTap: () => bloc.add(Downvote()),
          //   switchCondition: bloc.state.submission.voteState == VoteState_.Down,
          // ),
          // SquareActionButton(
          //   color: CupertinoColors.activeGreen,
          //   iconData: FontAwesomeIcons.bookmark,
          //   onTap: () => bloc.add(Save()),
          //   switchCondition: bloc.state.submission.saved == true,
          // ),
          // SquareActionButton(
          //   color: CupertinoColors.activeBlue,
          //   iconData: FontAwesomeIcons.reply,
          //   onTap: () => null,
          //   switchCondition: false,
          // ),
          // SquareActionButton(
          //   color: CupertinoColors.activeBlue,
          //   iconData: FontAwesomeIcons.shareSquare,
          //   onTap: () => null,
          //   switchCondition: false,
          // ),
        ],
      ),
    );
  }
}
