

import 'package:drago/comment_factory.dart';
import 'package:drago/common/common.dart';
import 'package:drago/screens/comments/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/blocs/comments_page_bloc/comments_page.dart';

class CommentsPage extends StatelessWidget {
  final String numComments;
  final SubmissionActions? submissionActions;
  final SubmissionSummary? submissionSummary;
  final Widget? topWidget;
  final Widget? bottomWidget;

  CommentsPage(
      {required this.numComments,
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
                topWidget!,
                bottomWidget!,
                submissionSummary!,
                submissionActions!,
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
