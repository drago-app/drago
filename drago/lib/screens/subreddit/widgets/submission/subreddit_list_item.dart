import 'package:drago/common/log_in_alert.dart';
import 'package:drago/common/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/common/common.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/screens/subreddit/widgets/widgets.dart';

class SubredditListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
      listener: (listenercontext, state) {
        if (state is SubmissionAuthError)
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoLogInAlert(
              context: context,
              titleText: state.title,
              contentText: state.content,
              onDismiss: () =>
                  BlocProvider.of<SubmissionBloc>(listenercontext).add(
                DialogDismissed(),
              ),
            ),
          );
      },
      builder: (context, state) {
        return CupertinoListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/comments',
                arguments: BlocProvider.of<SubmissionBloc>(context));
          },
          bottomRightCorner: SubmissionSave(
            submission: state.submission,
          ),
          leading: SubmissionThumbnail(
            submission: state.submission,
          ),
          title: Text(
            state.submission.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          subtitle: SubredditListItemBottomBar(submission: state.submission),
          trailing: Column(
            children: <Widget>[
              SquareActionButton(
                color: CupertinoColors.systemOrange,
                iconData: FontAwesomeIcons.longArrowAltUp,
                onTap: () =>
                    BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
                switchCondition: state.submission.voteState == VoteState_.Up,
              ),
              SquareActionButton(
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
        AuthorTextButton(author: submission.author, onTap: () => null),
        // FlairWidget(flairText: submission.authorFlairText),
        SubmissionScore(
            submission: submission,
            onTap: () =>
                BlocProvider.of<SubmissionBloc>(context).add(Upvote())),
        SubmissionNumComments(submission: submission),
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
  final Function onTap;

  CupertinoListTile({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.bottomRightCorner,
    this.onTap,
  }) : super(key: key);

  @override
  _StatefulStateCupertino createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context)),
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0, color: CupertinoColors.inactiveGray))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: widget.leading,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 60),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      widget.title,
                                      widget.subtitle
                                    ],
                                  ),
                                ),
                              ),
                              widget.trailing
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(bottom: 0, right: 0, child: widget.bottomRightCorner),
          ],
        ),
      ),
    );
  }
}
