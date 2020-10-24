import 'package:drago/dialog/dialog_provider.dart';
import 'package:drago/models/sort_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/blocs/subreddit_page_bloc/subreddit_page.dart';
import 'package:drago/common/common.dart';

import 'package:drago/main.dart';
import 'package:drago/screens/subreddit/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/features/subreddit/get_submissions.dart';

class SubredditPage extends StatefulWidget {
  SubredditPage();
  @override
  _SubredditPageState createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _SubredditPageState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocConsumer<SubredditPageBloc, SubredditPageState>(
          listener: (listenerContext, state) {
        if (state is DisplayingSortOptions) {
          showCupertinoModalPopup(
            useRootNavigator: true,
            context: context,
            builder: (context) => SubmissionsSortDialog(
              options: state.options,
              bloc: listenerContext.bloc<SubredditPageBloc>(),
            ),
          );
        }
        if (state is DisplayingFilterOptions) {
          showCupertinoModalPopup(
              context: listenerContext,
              builder: (context) => FilterDialog(
                    bloc: listenerContext.bloc<SubredditPageBloc>(),
                    filters: state.options,
                    option: state.sortType,
                  ));
        }
      }, buildWhen: (prev, current) {
        if (current is DisplayingSortOptions ||
            current is DisplayingFilterOptions) {
          return false;
        } else {
          return true;
        }
      }, builder: (bloccontext, state) {
        return CupertinoPageScaffold(
          child: _buildBody(state),
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text(
              '${state.subreddit}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CupertinoButton(
                    onPressed: () =>
                        BlocProvider.of<SubredditPageBloc>(bloccontext)
                            .add(UserTappedSortButton()),
                    padding: const EdgeInsets.all(0),
                    child: FaIcon(_mapStateToSortIcon(state.currentSort))),
                CupertinoButton(
                    onPressed: () => null,
                    padding: const EdgeInsets.all(0),
                    child: FaIcon(FontAwesomeIcons.ellipsisH)),
              ],
            ),
          ),
        );
      }),
    );
  }

  IconData _mapStateToSortIcon(SubmissionSortType type) {
    switch (type) {
      case SubmissionSortType.hot:
        return FontAwesomeIcons.fireAlt;
      case SubmissionSortType.top:
        return FontAwesomeIcons.thumbsUp;
      case SubmissionSortType.controversial:
        return FontAwesomeIcons.bomb;
      case SubmissionSortType.newest:
        return FontAwesomeIcons.clock;
      case SubmissionSortType.rising:
        return FontAwesomeIcons.chartLine;
    }
  }

  Widget _buildBody(SubredditPageState state) {
    if (state is SubredditPageInitial) {
      return Center(child: Text('SubredditPageInitial'));
    } else if (state is SubredditPageLoading) {
      return Center(child: LoadingIndicator());
    } else if (state is SubredditPageLoaded) {
      final _service = DialogProvider.of(context).service;
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: state.redditLinks.length,
        itemBuilder: (BuildContext context, int index) => BlocProvider(
          create: (BuildContext context) => SubmissionBloc(
              service: _service,
              redditLink: state.redditLinks[index],
              upvoteOrClear: upvoteOrClear,
              downvoteOrClear: downvoteOrClear,
              saveOrUnsave: saveOrUnsave),
          child: SubmissionWidgetFactory(),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<SubredditPageBloc>(context).add(LoadMore());
    }
  }
}

class SubmissionsSortDialog extends StatelessWidget {
  final List<SubmissionSortOption> options;
  final SubredditPageBloc bloc;

  SubmissionsSortDialog({@required this.bloc, @required this.options});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Sort by...'),
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: options
          .map((option) => SubmissionsSortDialogAction(option, bloc))
          .toList(),
    );
  }
}

class SubmissionsSortDialogAction extends StatelessWidget {
  final SubmissionSortOption option;
  final SubredditPageBloc bloc;
  SubmissionsSortDialogAction(this.option, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () {
        bloc.add(UserSelectedSortOption(sort: option));

        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            FaIcon(option.icon),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${option.label}'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (bloc.state.currentSort == option.type)
                          FaIcon(
                            FontAwesomeIcons.check,
                            size: 12,
                          ),
                        if (option.filterable)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: CupertinoColors.inactiveGray,
                              size: 12,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatelessWidget {
  final List<TimeFilterOption> filters;
  final SubredditPageBloc bloc;

  final SubmissionSortType option;

  FilterDialog(
      {@required this.option, @required this.bloc, @required this.filters});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Sort for by...'),
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: filters
          .map((f) => FilterDialogAction(option, f.filter, bloc))
          .toList(),
    );
  }
}

class FilterDialogAction extends StatelessWidget {
  final SubmissionSortType option;
  final TimeFilter_ filter;
  final SubredditPageBloc bloc;

  const FilterDialogAction(this.option, this.filter, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text('${SortUtils.timeFilterToString(filter)}'),
      onPressed: () => {
        Navigator.of(context).pop(),
        bloc.add(LoadSubmissions(sort: option, filter: filter)),
      },
    );
  }
}
