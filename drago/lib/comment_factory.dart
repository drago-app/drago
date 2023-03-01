import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/comment_bloc/comment.dart';
import 'blocs/more_comments_bloc/more_comments.dart';
import 'common/common.dart';
import 'main.dart';
import 'screens/comments/widgets/widgets.dart';

class CommentFactory extends StatelessWidget {
  final BaseCommentModel? comment;
  static final List colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  const CommentFactory({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comment is CommentModel) {
      return BlocProvider(
        create: (context) =>
            CommentBloc(getMoreComments: getMoreComments, comment: comment!),
        child: Builder(
          builder: (context) => BlocConsumer<CommentBloc, CommentState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentInitial) {
                  return CommentWidget(
                      colors: colors,
                      scoreViewModel: ScoreViewModel(
                          score: (comment as CommentModel).score,
                          voteState: (comment as CommentModel).voteState,
                          onTap: () {
                            print(
                                '[CommentFactory] voting is not enabled on comments');
                          }),
                      authorViewModel: AuthorViewModel(
                          defaultColor: CupertinoColors.label,
                          author: (comment as CommentModel).author,
                          onTap: () {
                            print(
                                '[CommentFactory] need to update AuthorModel to redirect to user account page');
                          }),
                      comment: comment as CommentModel?,
                      children: (comment as CommentModel)
                          .children
                          .map((child) => CommentFactory(comment: child))
                          .toList());
                }
                return Placeholder(child: Text("CommentFactory"));
              }),
        ),
      );
    } else {
      return BlocProvider(
        create: (context) => MoreCommentsBloc(
            getMoreComments: getMoreComments,
            more: comment as MoreCommentsModel),
        child: Builder(
          builder: (context) =>
              BlocConsumer<MoreCommentsBloc, MoreCommentsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is MoreCommentsInitial) {
                      return MoreCommentsWidget(
                        comment as MoreCommentsModel?,
                        onTap: () =>
                            BlocProvider.of<MoreCommentsBloc>(context).add(
                          LoadMoreComments(),
                        ),
                      );
                    } else if (state is MoreCommentsLoading) {
                      return Center(child: LoadingIndicator());
                    } else if (state is MoreCommentsLoaded) {
                      return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: state.expandedComments
                              .map((c) => CommentFactory(comment: c))
                              .toList());
                    } else {
                      return Placeholder();
                    }
                  }),
        ),
      );
    }
  }
}

// return BlocProvider(
//     create: (context) =>
//         CommentBloc(getMoreComments: getMoreComments, comment: comment),
//     child: Builder(
//       builder: (context) => BlocConsumer<CommentBloc, CommentState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           if (state is CommentInitial) {
//             return (comment is CommentModel)
//                 ? CommentWidget(
//                     colors: colors,
//                     scoreViewModel: ScoreViewModel(
//                         score: (comment as CommentModel).score,
//                         voteState: (comment as CommentModel).voteState,
//                         onTap: () {
//                           print(
//                               '[CommentFactory] voting is not enabled on comments');
//                         }),
//                     authorViewModel: AuthorViewModel(
//                         defaultColor: CupertinoColors.label,
//                         author: (comment as CommentModel).author,
//                         onTap: () {
//                           print(
//                               '[CommentFactory] need to update AuthorModel to redirect to user account page');
//                         }),
//                     comment: comment,
//                     children: (comment as CommentModel)
//                         .children
//                         .map((child) => CommentFactory(comment: child))
//                         .toList())
//                 : (comment is MoreCommentsModel)
// ? MoreCommentsWidget(
//     comment,
//     onTap: () =>
//         BlocProvider.of<CommentBloc>(context).add(
//       LoadMoreComments(
//           (comment as MoreCommentsModel).data,
//           comment.submissionId),
//     ),
//   )
//                     : ContinueThreadWidget(
//                         continueThread: comment,
//                       );
//           } else if (state is CommentsLoaded) {
// return ListView(
//     physics: NeverScrollableScrollPhysics(),
//     shrinkWrap: true,
//     children: state.comments
//         .map((c) => CommentFactory(comment: c))
//         .toList());
//           } else {
//             return Center(child: LoadingIndicator());
//           }
//         },
//       ),
//     )

//     );
