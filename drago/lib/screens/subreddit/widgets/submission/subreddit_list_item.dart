import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helius/blocs/submission_bloc.dart/submission.dart';
import 'package:helius/common/common.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/screens/subreddit/widgets/widgets.dart';

class SubredditListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        return CupertinoListTile(
          bottomRightCorner: SubmissionSave(
            submission: state.submission,
          ),
          leading: SubmissionThumbnail(
            submission: state.submission,
          ),
          title: Text(
            state.submission.title,
          ),
          subtitle: SubredditListItemBottomBar(submission: state.submission),
          trailing: Column(
            children: <Widget>[
              VoteButton(
                color: CupertinoColors.systemOrange,
                iconData: FontAwesomeIcons.longArrowAltUp,
                onTap: () =>
                    BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
                switchCondition: state.submission.voteState == VoteState_.Up,
              ),
              VoteButton(
                color: CupertinoColors.systemPurple,
                iconData: FontAwesomeIcons.longArrowAltDown,
                onTap: () =>
                    BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
                switchCondition: state.submission.voteState == VoteState_.Down,
              )
            ],
          ),
        );
      },
    );
  }
}

class SubredditListItemBottomBar extends StatelessWidget {
  final SubmissionModel submission;

  SubredditListItemBottomBar({@required this.submission});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      spacing: 4,
      children: <Widget>[
        AuthorWidget(author: submission.author, onTap: () => null),
        // FlairWidget(flairText: submission.authorFlairText),
        SubmissionScore(
            submission: submission,
            onTap: () =>
                BlocProvider.of<SubmissionBloc>(context).add(Upvote())),
        SubmissionNumComments(numComments: submission.numComments),
        SubmissionAge(age: submission.age),
        _optionsButton(context, submission)
      ],
    );
  }

  _actionSheet(context, item) {
    const x = 10;
    return Container(
        child: CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
          for (var i = 0; i < x; i++)
            CupertinoActionSheetAction(
                onPressed: () => null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(CupertinoIcons.create),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 24),
                            alignment: Alignment(-1, 0),
                            child: Text('asd')))
                  ],
                )),
        ]));
  }

  _optionsButton(BuildContext context, item) {
    return GestureDetector(
        onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => Container(
                constraints: BoxConstraints(maxHeight: 600),
                child: _actionSheet(context, item))),
        child: Icon(CupertinoIcons.ellipsis));
  }
}

class CupertinoListTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final Widget bottomRightCorner;

  CupertinoListTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.bottomRightCorner})
      : super(key: key);

  @override
  _StatefulStateCupertino createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(bottom: 0, right: 0, child: widget.bottomRightCorner),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Container(
            padding: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: CupertinoColors.lightBackgroundGray))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: widget.leading,
                  flex: 3,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.title,
                      widget.subtitle,
                    ],
                  ),
                  flex: 5,
                ),
                Flexible(child: widget.trailing, flex: 1)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
