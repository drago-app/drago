import 'package:drago/common/comment.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/log_in_alert.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/common/text_button.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/comments_page_bloc/comments_page.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';

import 'widgets/submission/submission.dart';
import 'widgets/submission/submission_ratio.dart';
import 'widgets/submission/vote_button.dart';

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
              middle: Text(
                  '${submissionState.submission.numComments.asString} Comments'),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Picture(
                    maxHeight: MediaQuery.of(context).size.height * .5,
                    url: submissionState.submission.preview.thumbnailUrl,
                  ),
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
  final SubmissionModel submission;
  final SubmissionBloc bloc;

  const _SubmissionDetails({this.submission, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${submission.title}'),
          Row(
            children: [
              Text('in '),
              TextButton(
                '${submission.subredditName}',
                onTap: () => Navigator.of(context).pushNamed('/subreddit',
                    arguments: submission.subredditName),
              ),
              Text(' by '),
              AuthorTextButton(
                onTap: () => print(
                    '[FROM COMMENTS PAGE] --- need to navigate to a user page when implemented'),
                author: submission.author,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SubmissionScore(
                onTap: () => bloc.add(Upvote()),
                submission: submission,
              ),
              SubmissionRatio(submission: submission),
              SubmissionAge(
                age: submission.age,
              )
            ],
          ),
          _SubmissionActions(bloc: bloc, submission: submission)
        ],
      ),
    );
  }
}

class _SubmissionActions extends StatelessWidget {
  final SubmissionModel submission;
  final SubmissionBloc bloc;

  const _SubmissionActions({this.submission, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 0, color: CupertinoColors.separator))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SquareActionButton(
          color: CupertinoColors.activeOrange,
          iconData: FontAwesomeIcons.longArrowAltUp,
          onTap: () => bloc.add(Upvote()),
          switchCondition: bloc.state.submission.voteState == VoteState_.Up,
        ),
        SquareActionButton(
          color: CupertinoColors.systemPurple,
          iconData: FontAwesomeIcons.longArrowAltDown,
          onTap: () => bloc.add(Downvote()),
          switchCondition: bloc.state.submission.voteState == VoteState_.Down,
        ),
        SquareActionButton(
          color: CupertinoColors.activeGreen,
          iconData: FontAwesomeIcons.bookmark,
          onTap: () => bloc.add(Save()),
          switchCondition: bloc.state.submission.saved == true,
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
      ]),
    );
  }
}
