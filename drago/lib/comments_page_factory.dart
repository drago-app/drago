import 'package:drago/screens/comments/comments_page.dart';
import 'package:drago/screens/comments/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/submission_bloc.dart/submission.dart';
import 'common/common.dart';
import 'features/subreddit/get_submissions.dart';

class CommentsPageFactory extends StatelessWidget {
  final SubmissionBloc submissionBloc;

  const CommentsPageFactory({Key key, @required this.submissionBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
        bloc: submissionBloc,
        listener: (listenerContext, state) {},
        builder: (builderContext, state) {
          if (state.submission is SelfSubmission)
            return selfSubmissionCommentsPage(submissionBloc);
          if (state.submission is WebSubmission) {
            return linkSubmissionCommentsPage(submissionBloc);
          }
        });
  }
}

Widget linkSubmissionCommentsPage(submissionBloc) => CommentsPage(
      numComments: submissionBloc.state.submission.numComments.toString(),
      bottomWidget: Text('${submissionBloc.state.submission.url}'),
      topWidget: SubmissionTitleWidget(submissionBloc.state.submission.title),
      submissionSummary: SubmissionSummary(
        subreddit: submissionBloc.state.submission.subreddit,
        authorViewModel: AuthorViewModel(
          author: submissionBloc.state.submission.author,
          onTap: (BuildContext context) => Navigator.of(context).pushNamed(
              '/account',
              arguments: submissionBloc.state.submission.author.name),
        ),
        scoreViewModel: ScoreViewModel(
          onTap: (_) => submissionBloc.add(Upvote()),
          score: submissionBloc.state.submission.score,
          voteState: submissionBloc.state.submission.voteState,
        ),
      ),
      submissionActions: SubmissionActions(
        onUpVote: () => submissionBloc.add(Upvote()),
        onDownVote: () => submissionBloc.add(Downvote()),
        onSave: (context) => submissionBloc.add(Save()),
        saved: submissionBloc.state.submission.saved,
        voteState: submissionBloc.state.submission.voteState,
      ),
    );

Widget selfSubmissionCommentsPage(submissionBloc) => CommentsPage(
      numComments: submissionBloc.state.submission.numComments.toString(),
      bottomWidget: SelfSubmissionBodyWidget(
          (submissionBloc.state.submission as SelfSubmission).body),
      topWidget: SubmissionTitleWidget(submissionBloc.state.submission.title),
      submissionSummary: SubmissionSummary(
        subreddit: submissionBloc.state.submission.subreddit,
        authorViewModel: AuthorViewModel(
          author: submissionBloc.state.submission.author,
          onTap: (BuildContext context) => Navigator.of(context).pushNamed(
              '/account',
              arguments: submissionBloc.state.submission.author.name),
        ),
        scoreViewModel: ScoreViewModel(
          onTap: (_) => submissionBloc.add(Upvote()),
          score: submissionBloc.state.submission.score,
          voteState: submissionBloc.state.submission.voteState,
        ),
      ),
      submissionActions: SubmissionActions(
        onUpVote: () => submissionBloc.add(Upvote()),
        onDownVote: () => submissionBloc.add(Downvote()),
        onSave: (context) => submissionBloc.add(Save()),
        saved: submissionBloc.state.submission.saved,
        voteState: submissionBloc.state.submission.voteState,
      ),
    );
