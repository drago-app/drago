import 'package:drago/features/subreddit/set_user_flair.dart';
import '../../../icons_enum.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class SetUserFlairAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  SetUserFlair usecase;

  SetUserFlairAction(this.usecase) : assert(usecase != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel(
          (bloc) => _states(bloc), DragoIcons.set_user_flair, "Set User Flair");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure = await usecase(SetUserFlairParams(bloc.subreddit));
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
        redditLinks: bloc.state.redditLinks!,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}
