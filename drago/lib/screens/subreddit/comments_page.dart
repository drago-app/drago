import 'package:drago/common/comment.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/text_button.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/comment_model.dart';
import 'package:drago/screens/subreddit/widgets/submission/vote_button.dart';
import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/blocs/comments_page_bloc/comments_page.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';

import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/submission/submission_score.dart';

// class SubmissionContentWidget extends StatelessWidget {
//   final Submission submission;
//   SubmissionContentWidget({@required this.submission});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.shrink();
//     if (submission.content is ImageSubmissionContent) {
//       return MediaSubmissionWidget(
//         mediaWidget: Picture(
//           maxHeight: MediaQuery.of(context).size.height * .5,
//           url: submission.content.content.url,
//         ),
//         titleWidget: SubmissionTitle(
//           submission: submission,
//         ),
//       );
//     } else if (submission.content is GifSubmissionContent) {
//       return MediaSubmissionWidget(
//         titleWidget: SubmissionTitle(submission: submission),
//         mediaWidget: Picture(
//           maxHeight: MediaQuery.of(context).size.height * .5,
//           url: submission.content.content.url,
//         ),
//       );
//     } else if (submission.content is SelfSubmissionContent) {
//       return SelfOrLinkSubmissionWidget(
//         titleWidget: SubmissionTitle(
//           submission: submission,
//         ),
//         submissionWidget: md.MarkdownBody(
//             data: submission.content.content,
//             styleSheet: MarkdownTheme.of(context)),
//       );
//     }
//   }
// }

// class MediaSubmissionWidget extends StatelessWidget {
//   final Widget mediaWidget;
//   final Widget titleWidget;
//   MediaSubmissionWidget(
//       {@required this.mediaWidget, @required this.titleWidget});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         mediaWidget,
//         Container(
//             width: MediaQuery.of(context).size.width,
//             color: CupertinoTheme.of(context).barBackgroundColor,
//             padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//             child: titleWidget),
//       ],
//     );
//   }
// }

class SelfSubmissionBodyWidget extends StatelessWidget {
  final String bodyText;

  SelfSubmissionBodyWidget(this.bodyText) : assert(bodyText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: CupertinoTheme.of(context).barBackgroundColor,
        child: md.MarkdownBody(
            data: bodyText, styleSheet: MarkdownTheme.of(context)));
  }
}

class SubmissionTitleWidget extends StatelessWidget {
  final String title;

  const SubmissionTitleWidget(this.title, {Key key})
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

class CommentsPageFactory extends StatelessWidget {
  final SubmissionBloc submissionBloc;

  const CommentsPageFactory({Key key, @required this.submissionBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
      bloc: submissionBloc,
      listener: (listenerState, state) {},
      builder: (builderContext, state) => CommentsPage(
        submissionBloc: submissionBloc,
        bottomWidget: SelfSubmissionBodyWidget(
            (submissionBloc.state.submission as SelfSubmission).body),
        topWidget: SubmissionTitleWidget(submissionBloc.state.submission.title),
        submissionSummary: SubmissionSummary(
          subreddit: submissionBloc.state.submission.subreddit,
          authorViewModel:
              AuthorViewModel(author: submissionBloc.state.submission.author),
          scoreViewModel: ScoreViewModel(
              onTap: (_) => submissionBloc.add(Upvote()),
              score: submissionBloc.state.submission.score,
              voteState: submissionBloc.state.submission.voteState),
        ),
        submissionActions: SubmissionActions(
            onUpVote: () => submissionBloc.add(Upvote()),
            onDownVote: () => submissionBloc.add(Downvote()),
            onSave: (context) => submissionBloc.add(Save()),
            saved: submissionBloc.state.submission.saved,
            voteState: submissionBloc.state.submission.voteState),
      ),
    );
  }
}

class CommentsPage extends StatelessWidget {
  final SubmissionBloc submissionBloc;
  final SubmissionActions submissionActions;
  final SubmissionSummary submissionSummary;
  final Widget topWidget;
  final Widget bottomWidget;

  CommentsPage(
      {@required this.submissionBloc,
      this.submissionActions,
      this.submissionSummary,
      this.topWidget,
      this.bottomWidget})
      : assert(submissionBloc != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            '${submissionBloc.state.submission.numComments.toString()} Comments'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                topWidget,
                bottomWidget,
                submissionSummary,
                submissionActions,
                _comments()
              ],
            )),
      ),
    );
  }
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
          // _SubmissionActions(bloc: bloc, submission: submission)
        ],
      ),
    );
  }
}

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
