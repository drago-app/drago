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

// class SubmissionContentWidget extends StatelessWidget {
//   final Submission submission;
//   SubmissionContentWidget({@required this.submission});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.shrink();
//     if (submission.content is ImageSubmissionContent) {
//       return MediaSubmissionWidget(
//         mediaWidget:
// Picture(
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
