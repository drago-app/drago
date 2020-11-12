import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/comment_bloc/comment.dart';
import 'common/common.dart';
import 'main.dart';
import 'screens/comments/widgets/widgets.dart';

class CommentFactory extends StatelessWidget {
  final BaseCommentModel comment;
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
    Key key,
    @required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CommentBloc(getMoreComments: getMoreComments, comment: comment),
        child: Builder(
          builder: (context) => BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is CommentInitial) {
                return (comment is CommentModel)
                    ? CommentWidget(
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
                        comment: comment,
                        children: (comment as CommentModel)
                            .children
                            .map((child) => CommentFactory(comment: child))
                            .toList())
                    : (comment is MoreCommentsModel)
                        ? MoreCommentsWidget(
                            comment,
                            onTap: () =>
                                BlocProvider.of<CommentBloc>(context).add(
                              LoadMoreComments(
                                  (comment as MoreCommentsModel).data,
                                  comment.submissionId),
                            ),
                          )
                        : ContinueThreadWidget(
                            continueThread: comment,
                          );
              } else if (state is CommentsLoaded) {
                return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: state.comments
                        .map((c) => CommentFactory(comment: c))
                        .toList());
              } else {
                return Center(child: LoadingIndicator());
              }
            },
          ),
        )

        // child: (comment is CommentModel)
        //     ? CommentWidget(
        //         colors: colors,
        //         scoreViewModel: ScoreViewModel(
        //             score: (comment as CommentModel).score,
        //             voteState: (comment as CommentModel).voteState,
        //             onTap: () {
        //               print('[CommentFactory] voting is not enabled on comments');
        //             }),
        //         authorViewModel: AuthorViewModel(
        //             defaultColor: CupertinoColors.label,
        //             author: (comment as CommentModel).author,
        //             onTap: () {
        //               print(
        //                   '[CommentFactory] need to update AuthorModel to redirect to user account page');
        //             }),
        //         comment: comment,
        //         children: (comment as CommentModel)
        //             .children
        //             .map((child) => CommentFactory(comment: child))
        //             .toList())
        //     : (comment is MoreCommentsModel)
        //         ? MoreCommentsWidget(comment)
        //         : ContinueThreadWidget(
        //             continueThread: comment,
        //           ),
        );
  }
}
