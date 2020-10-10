import 'package:drago/common/common.dart';
import 'package:drago/common/drag_to_pop_modal/drag_to_pop_page_route.dart';
import 'package:drago/common/log_in_alert.dart';
import 'package:drago/common/text_button.dart';
import 'package:drago/sandbox/host.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/screens/subreddit/widgets/widgets.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionWidgetFactory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
        listener: (listenerContext, state) {},
        builder: (builderContext, state) {
          if (state.submission is SelfSubmission)
            return selfSubmission(state.submission);
          if (state.submission is WebSubmission)
            return linkSubmission(state.submission);
          if (state.submission is MediaSubmission) {
            if ((state.submission as MediaSubmission).media is VideoMedia) {
              return mediaSubmission(
                  state.submission,
                  SubmissionThumbnail(
                    label: VideoThumbnailLabel(),
                    previewUrl: state.submission.previewUrl,
                  ));
            }
            if ((state.submission as MediaSubmission).media is GifMedia) {
              return mediaSubmission(
                  state.submission,
                  SubmissionThumbnail(
                    label: GifThumbnailLabel(),
                    previewUrl: state.submission.previewUrl,
                  ));
            }
            if ((state.submission as MediaSubmission).media is GalleryMedia) {
              return mediaSubmission(
                  state.submission,
                  SubmissionThumbnail(
                    label: GalleryThumbnailLabel(
                        (state.submission as MediaSubmission).media),
                    previewUrl: state.submission.previewUrl,
                  ));
            }
            if ((state.submission as MediaSubmission).media is ImageMedia) {
              return mediaSubmission(
                  state.submission,
                  SubmissionThumbnail(
                    previewUrl: state.submission.previewUrl,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        DragToPopPageRoute(
                          builder: (_) => SecondPage(
                            bloc: context.bloc<SubmissionBloc>(),
                          ),
                        ),
                      );
                    },
                  ));
            }
          }

          return SizedBox.shrink();
        });
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget mediaSubmission(Submission submission, Widget thumbnail) =>
    SubredditListItem(
        saved: submission.saved,
        title: submission.title,
        voteState: submission.voteState,
        authorFlairText: submission.authorFlairText,
        linkFlairText: submission.linkFlairText,
        onUpVote: (context) =>
            BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
        onDownVote: (context) =>
            BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
        onTap: null,
        thumbnail: thumbnail,
        authorViewModel:
            AuthorViewModel(author: submission.author, onTap: null),
        scoreViewModel: ScoreViewModel(
          score: submission.score,
          voteState: submission.voteState,
          onTap: (context) =>
              BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
        ),
        numCommentsViewModel: NumCommentsViewModel(submission.numComments),
        nsfw: submission.isNSFW);

Widget linkSubmission(Submission submission) => SubredditListItem(
    saved: submission.saved,
    title: submission.title,
    authorFlairText: submission.authorFlairText,
    linkFlairText: submission.linkFlairText,
    voteState: submission.voteState,
    onUpVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    onDownVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
    onTap: (context) => Navigator.of(context).pushNamed('/comments',
        arguments: BlocProvider.of<SubmissionBloc>(context)),
    thumbnail: SubmissionThumbnail(
      onTap: () => _launchURL(submission.url),
      label: LinkThumbnailLabel(),
      previewUrl: submission.previewUrl ?? 'https://via.placeholder.com/150',
    ),
    authorViewModel: AuthorViewModel(author: submission.author, onTap: null),
    scoreViewModel: ScoreViewModel(
      score: submission.score,
      voteState: submission.voteState,
      onTap: (context) =>
          BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    ),
    numCommentsViewModel: NumCommentsViewModel(submission.numComments),
    nsfw: submission.isNSFW);

Widget selfSubmission(Submission submission) => SubredditListItem(
    saved: submission.saved,
    title: submission.title,
    authorFlairText: submission.authorFlairText,
    linkFlairText: submission.linkFlairText,
    voteState: submission.voteState,
    onUpVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    onDownVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
    onTap: (context) => Navigator.of(context).pushNamed('/comments',
        arguments: BlocProvider.of<SubmissionBloc>(context)),
    thumbnail: SubmissionThumbnail(
      onTap: null,
      previewUrl: 'https://via.placeholder.com/150',
    ),
    authorViewModel: AuthorViewModel(author: submission.author, onTap: null),
    scoreViewModel: ScoreViewModel(
      score: submission.score,
      voteState: submission.voteState,
      onTap: (context) =>
          BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    ),
    numCommentsViewModel: NumCommentsViewModel(submission.numComments),
    nsfw: submission.isNSFW);

class SubredditListItem extends StatelessWidget {
  final Function onTap;
  final String title, authorFlairText, linkFlairText;
  final VoteState voteState;
  final Function onUpVote;
  final Function onDownVote;
  final Widget thumbnail;
  final bool saved, nsfw;
  final AuthorViewModel authorViewModel;
  final ScoreViewModel scoreViewModel;
  final NumCommentsViewModel numCommentsViewModel;

  const SubredditListItem(
      {Key key,
      @required this.thumbnail,
      @required this.title,
      @required this.authorFlairText,
      @required this.linkFlairText,
      @required this.voteState,
      @required this.onUpVote,
      @required this.onDownVote,
      @required this.onTap,
      @required this.saved,
      @required this.nsfw,
      @required this.authorViewModel,
      @required this.scoreViewModel,
      @required this.numCommentsViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: () => onTap(context),
      bottomRightCorner: SubmissionSave(saved: saved),
      leading: thumbnail,
      title: RichText(
        text: TextSpan(
            text: '$title ',
            style: CupertinoTheme.of(context).textTheme.textStyle,
            children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: NSFWFlairWidget(nsfw)),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: FlairWidget(flairText: linkFlairText))
            ]),
      ),
      subtitle: SubredditListItemBottomBar(
          author: authorViewModel,
          numComments: numCommentsViewModel,
          authorFlairText: authorFlairText,
          age: null,
          score: scoreViewModel),
      trailing: Column(
        children: <Widget>[
          SquareActionButton(
            color: CupertinoColors.systemOrange,
            iconData: FontAwesomeIcons.longArrowAltUp,
            onTap: () => onUpVote(context),
            switchCondition: voteState == VoteState.Up,
          ),
          SquareActionButton(
            color: CupertinoColors.systemPurple,
            iconData: FontAwesomeIcons.longArrowAltDown,
            onTap: () => onDownVote,
            switchCondition: voteState == VoteState.Down,
          )
        ],
      ),
    );
  }
}

class SubredditListItemBottomBar extends StatelessWidget {
  // final Submission submission;
  final String age;
  final AuthorViewModel author;
  final ScoreViewModel score;
  final NumCommentsViewModel numComments;
  final String authorFlairText;

  SubredditListItemBottomBar(
      {@required this.age,
      @required this.author,
      @required this.authorFlairText,
      @required this.score,
      @required this.numComments});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      spacing: 4,
      children: <Widget>[
        AuthorWidget(author),
        FlairWidget(flairText: authorFlairText),
        ScoreWidget(score),

        NumCommentsWidget(numComments),
        // SubmissionAge(age: age),
        // _optionsButton(context, submission)
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
  bool _isPressed = false;
  static const Color _kBackgroundColorPressed = Color(0xFFDDDDDD);
  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: Container(
        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            color: _isPressed
                ? _kBackgroundColorPressed
                : CupertinoColors.systemBackground.resolveFrom(context)),
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0, color: CupertinoColors.separator))),
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
                                      widget.title ?? SizedBox.shrink(),
                                      widget.subtitle ?? SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              ),
                              widget.trailing ?? SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: widget.bottomRightCorner ?? SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
