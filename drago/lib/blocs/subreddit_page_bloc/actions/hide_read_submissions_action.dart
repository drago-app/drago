import 'package:drago/features/subreddit/hide_read_submissions.dart';

import '../../../icons_enum.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class HideReadSubmissionsAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  HideReadSubmissions usecase;

  HideReadSubmissionsAction(this.usecase) : assert(usecase != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel((bloc) => _states(bloc), DragoIcons.hide_read_posts,
          "Hide Read Posts");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure =
        await usecase(HideReadSubmissionsParams(bloc.subreddit));
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
