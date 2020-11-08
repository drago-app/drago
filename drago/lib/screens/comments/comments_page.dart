import 'package:drago/blocs/comment_bloc/comment.dart';
import 'package:drago/common/common.dart';

import 'package:drago/models/comment_model.dart';
import 'package:drago/screens/comments/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/blocs/comments_page_bloc/comments_page.dart';

class CommentsPage extends StatelessWidget {
  final String numComments;
  final SubmissionActions submissionActions;
  final SubmissionSummary submissionSummary;
  final Widget topWidget;
  final Widget bottomWidget;

  CommentsPage(
      {@required this.numComments,
      this.submissionActions,
      this.submissionSummary,
      this.topWidget,
      this.bottomWidget});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          CupertinoNavigationBar(middle: Text('$numComments Comments')),
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
          return CommentFactory(
            comment: commentsState.comments[index],
          );
        },
      );
    } else {
      return Center(child: LoadingIndicator());
    }
  });
}

class CommentFactory extends StatelessWidget {
  final BaseCommentModel comment;
  static final List colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple
  ];

  const CommentFactory({
    Key key,
    @required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentBloc(comment: comment),
      child: (comment is CommentModel)
          ? CommentWidget(
              colors: colors,
              scoreViewModel: ScoreViewModel(
                  score: (comment as CommentModel).score,
                  voteState: (comment as CommentModel).voteState,
                  onTap: () {
                    print('[CommentFactory] voting is not enabled on comments');
                  }),
              authorViewModel: AuthorViewModel(
                  defaultColor: CupertinoColors.label,
                  author: (comment as CommentModel).author,
                  onTap: () {
                    print(
                        '[CommentFactory] need to update AuthorModel to redirect to user account page');
                  }),
              comment: comment,
              children: (comment as CommentModel)
                  .children
                  .map((child) => CommentFactory(comment: child))
                  .toList())
          : (comment is MoreCommentsModel)
              ? MoreCommentsWidget(comment)
              : ContinueThreadWidget(
                  continueThread: comment,
                ),
    );
  }
}
