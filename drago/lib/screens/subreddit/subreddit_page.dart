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
      child: BlocBuilder<SubredditPageBloc, SubredditPageState>(
          builder: (bloccontext, state) {
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
                    onPressed: () => showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              SubmissionsSortDialog(
                            bloc:
                                BlocProvider.of<SubredditPageBloc>(bloccontext),
                          ),
                        ),
                    padding: EdgeInsets.all(0),
                    child: FaIcon(_mapStateToSortIcon(state.currentSort))),
                CupertinoButton(
                    onPressed: () => null,
                    padding: EdgeInsets.all(0),
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
        itemCount: state.submissions.length,
        itemBuilder: (BuildContext context, int index) => BlocProvider(
          create: (BuildContext context) => SubmissionBloc(
              service: _service,
              submission: state.submissions[index],
              upvoteOrClear: upvoteOrClear,
              downvoteOrClear: downvoteOrClear,
              saveOrUnsave: saveOrUnsave),
          child: SubredditListItem(),
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
  final List<SubmissionSortOption> options = [
    SubmissionSortOption.factory(type: SubmissionSortType.hot, selected: true),
    SubmissionSortOption.factory(type: SubmissionSortType.top),
    SubmissionSortOption.factory(type: SubmissionSortType.controversial),
    SubmissionSortOption.factory(type: SubmissionSortType.newest),
    SubmissionSortOption.factory(type: SubmissionSortType.rising),
  ];
  final SubredditPageBloc bloc;

  SubmissionsSortDialog({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Sort by...'),
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: options
          .map((option) => (option.filterable == true)
              ? FilterableSubmissionsSortDialogAction(option, bloc)
              : SubmissionsSortDialogAction(option, bloc))
          .toList(),
    );
  }
}

class FilterableSubmissionsSortDialogAction extends StatelessWidget {
  final SubmissionSortOption option;
  final SubredditPageBloc bloc;
  FilterableSubmissionsSortDialogAction(this.option, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.of(context).pop();
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => FilterDialog(option, bloc),
        );
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
                    FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: CupertinoColors.inactiveGray,
                      size: 12,
                    ),
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

class SubmissionsSortDialogAction extends StatelessWidget {
  final SubmissionSortOption option;
  final SubredditPageBloc bloc;
  SubmissionsSortDialogAction(this.option, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () {
        bloc.add(LoadSubmissions(sort: option.type));
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
                    if (bloc.state.currentSort == option.type)
                      FaIcon(
                        FontAwesomeIcons.check,
                        size: 12,
                      ),
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
  final List<TimeFilter_> filters = [
    TimeFilter_.all,
    TimeFilter_.day,
    TimeFilter_.week,
    TimeFilter_.month,
    TimeFilter_.year
  ];
  final SubredditPageBloc bloc;

  final SubmissionSortOption option;

  FilterDialog(this.option, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Sort by...'),
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: filters.map((f) => FilterDialogAction(option, f, bloc)).toList(),
    );
  }
}

class FilterDialogAction extends StatelessWidget {
  final SubmissionSortOption option;
  final TimeFilter_ filter;
  final SubredditPageBloc bloc;

  const FilterDialogAction(this.option, this.filter, this.bloc);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text('${SortUtils.timeFilterToString(filter)}'),
      onPressed: () => {
        Navigator.of(context).pop(),
        bloc.add(LoadSubmissions(sort: option.type, filter: filter)),
      },
    );
  }
}
