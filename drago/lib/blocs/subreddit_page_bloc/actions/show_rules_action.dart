import 'package:drago/features/subreddit/hide_read_submissions.dart';
import 'package:drago/features/subreddit/subreddit.dart';

import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class ShowRulesAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  GetSubredditRules usecase;

  ShowRulesAction(this.usecase) : assert(usecase != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel((bloc) => _states(bloc), null, "Subreddit Rules");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure =
        await usecase(GetSubredditRulesParams(bloc.subreddit));
    yield* unitOrFailure.fold((failure) async* {
      yield SubredditPageError(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
        error: failure.message,
      );
    }, (_) async* {
      yield SubredditPageLoaded(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}
