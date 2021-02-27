import 'package:drago/dialog/dialog_provider.dart';
import 'package:drago/icons_enum.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/screens/subreddit/widgets/submission/submission_widget_factory.dart';
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
  final _scrollThreshold = 300.0;

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
              context: listenerContext,
              builder: (context) => CupertinoActionSheet(
                  actions: state.options
                      .map((a) => DialogAction(action: a))
                      .toList()));
        }
        // if (state is DisplayingFilterOptions) {
        //   showCupertinoModalPopup(
        //       context: listenerContext,
        //       builder: (context) => FilterDialog(
        //             bloc: listenerContext.bloc<SubredditPageBloc>(),
        //             filters: state.options,
        //             option: state.sortType,
        //           ));
        // }
      }, buildWhen: (prev, current) {
        return !(current is DisplayingSortOptions);
        // if (current is DisplayingSortOptions ||
        //     current is DisplayingFilterOptions) {
        //   return false;
        // } else {
        //   return true;
        // }
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
                  child: Icon(getIconData(state.currentSort.icon)),
                ),
                CupertinoButton(
                    onPressed: () => null,
                    padding: const EdgeInsets.all(0),
                    child: Icon(CupertinoIcons.ellipsis)),
              ],
            ),
          ),
        );
      }),
    );
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

class DialogAction extends StatelessWidget {
  final ActionModel action;
  DialogAction({this.action});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () {
        action.action();
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(getIconData(action.icon)),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${action.description}'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        (action.selected)
                            ? Icon(getIconData(DragoIcons.selected))
                            : SizedBox.shrink(),
                        (action.hasOptions)
                            ? Icon(getIconData(DragoIcons.chevron_right))
                            : SizedBox.shrink()
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
