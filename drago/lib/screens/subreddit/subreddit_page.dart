import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helius/blocs/submission_bloc.dart/submission.dart';
import 'package:helius/blocs/subreddit_page_bloc/subreddit_page.dart';
import 'package:helius/common/common.dart';

import 'package:helius/main.dart';
import 'package:helius/screens/subreddit/widgets/widgets.dart';

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
          builder: (context, state) {
        return CupertinoPageScaffold(
          child: _buildBody(state),
          navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: true,
              middle: Text('${state.subreddit}')),
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
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: state.submissions.length,
        itemBuilder: (BuildContext context, int index) => BlocProvider(
          create: (BuildContext context) => SubmissionBloc(
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
