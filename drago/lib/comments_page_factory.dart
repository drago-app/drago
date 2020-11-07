import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/screens/comments/comments_page.dart';
import 'package:drago/screens/comments/widgets/widgets.dart';
import 'package:drago/screens/subreddit/widgets/submission/submission_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/submission_bloc.dart/submission.dart';
import 'common/common.dart';
import 'common/drag_to_pop_modal/drag_to_pop_page_route.dart';
import 'features/subreddit/get_submissions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

class CommentsPageFactory extends StatefulWidget {
  final SubmissionBloc submissionBloc;

  const CommentsPageFactory({Key key, @required this.submissionBloc})
      : super(key: key);

  @override
  _CommentsPageFactoryState createState() => _CommentsPageFactoryState();
}

class _CommentsPageFactoryState extends State<CommentsPageFactory> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
        bloc: widget.submissionBloc,
        listener: (listenerState, state) {},
        builder: (builderContext, state) {
          if (state.submission is SelfSubmission)
            return selfSubmissionCommentsPage(widget.submissionBloc);

          if (state.submission is MediaSubmission) {
            return mediaSubmissionCommentsPage(
                widget.submissionBloc,
                MediaQuery.of(context).size.height * .5,
                (state.submission as MediaSubmission).media);
          }
          return linkSubmissionCommentsPage(widget.submissionBloc);
        });
  }

  Widget mapMediaTypeToWidget(maxHeight, media) {
    if (media is ImageMedia) {
      return imageWidget(maxHeight, media);
    }
    if (media is GalleryMedia) {
      return galleryWidget(maxHeight, media);
    }
    if (media is GifMedia) {
      return gifWidget(maxHeight, media);
    }
  }

  Widget galleryWidget(maxHeight, GalleryMedia media) {
    final height = MediaQuery.of(context).size.height * .3;
    return Container(
      height: height,
      child: Stack(
        children: [
          StaggeredGridView.countBuilder(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) => Container(
              height: height,
              child: GalleryPreviewElement(
                media.src[index],
                height: height,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  DragToPopPageRoute(
                    builder: (_) => GalleryWidget(
                      media: media,
                      startingIndex: index,
                      bloc: widget.submissionBloc,
                    ),
                  ),
                ),
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.extent(2, height),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlairWidget(
                    flairText: '${media.size} IMAGES',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              ))
        ],
      ),
    );
  }

  Widget imageWidget(maxHeight, ImageMedia media) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        DragToPopPageRoute(
          builder: (_) => SecondPage(
            body: ImageViewerWidget(media),
            bloc: widget.submissionBloc,
          ),
        ),
      ),
      child: Hero(
        tag: widget.submissionBloc.state.submission.url,
        child: Picture(
          maxHeight: maxHeight,
          url: media.src,
        ),
      ),
    );
  }

  Widget gifWidget(maxHeight, GifMedia media) {
    return GestureDetector(
      // onTap: () => Navigator.of(context, rootNavigator: true).push(
      //   DragToPopPageRoute(
      //     builder: (_) => SecondPage(
      //       body: ImageViewerWidget(media),
      //       bloc: widget.submissionBloc,
      //     ),
      //   ),
      // ),
      child: Hero(
        tag: widget.submissionBloc.state.submission.url,
        child: Picture(
          maxHeight: maxHeight,
          url: media.src,
        ),
      ),
    );
  }

  Widget mediaSubmissionCommentsPage(
          submissionBloc, maxHeight, ExpandoMedia media) =>
      CommentsPage(
        numComments: submissionBloc.state.submission.numComments.toString(),
        topWidget: mapMediaTypeToWidget(maxHeight, media),
        bottomWidget:
            SubmissionTitleWidget(submissionBloc.state.submission.title),
        submissionSummary: SubmissionSummary(
          subreddit: submissionBloc.state.submission.subreddit,
          authorViewModel:
              AuthorViewModel(author: submissionBloc.state.submission.author),
          scoreViewModel: ScoreViewModel(
            onTap: (_) => submissionBloc.add(Upvote()),
            score: submissionBloc.state.submission.score,
            voteState: submissionBloc.state.submission.voteState,
          ),
        ),
        submissionActions: SubmissionActions(
          onUpVote: () => submissionBloc.add(Upvote()),
          onDownVote: () => submissionBloc.add(Downvote()),
          onSave: (context) => submissionBloc.add(Save()),
          saved: submissionBloc.state.submission.saved,
          voteState: submissionBloc.state.submission.voteState,
        ),
      );

  Widget linkSubmissionCommentsPage(submissionBloc) => CommentsPage(
        numComments: submissionBloc.state.submission.numComments.toString(),
        bottomWidget: LinkPreviewWidget(
          link: submissionBloc.state.submission.url,
          previewUrl: submissionBloc.state.submission.previewUrl,
        ),
        topWidget: SubmissionTitleWidget(submissionBloc.state.submission.title),
        submissionSummary: SubmissionSummary(
          subreddit: submissionBloc.state.submission.subreddit,
          authorViewModel:
              AuthorViewModel(author: submissionBloc.state.submission.author),
          scoreViewModel: ScoreViewModel(
            onTap: (_) => submissionBloc.add(Upvote()),
            score: submissionBloc.state.submission.score,
            voteState: submissionBloc.state.submission.voteState,
          ),
        ),
        submissionActions: SubmissionActions(
          onUpVote: () => submissionBloc.add(Upvote()),
          onDownVote: () => submissionBloc.add(Downvote()),
          onSave: (context) => submissionBloc.add(Save()),
          saved: submissionBloc.state.submission.saved,
          voteState: submissionBloc.state.submission.voteState,
        ),
      );

  Widget selfSubmissionCommentsPage(submissionBloc) => CommentsPage(
        numComments: submissionBloc.state.submission.numComments.toString(),
        bottomWidget: SelfSubmissionBodyWidget(
            (submissionBloc.state.submission as SelfSubmission).body),
        topWidget: SubmissionTitleWidget(submissionBloc.state.submission.title),
        submissionSummary: SubmissionSummary(
          subreddit: submissionBloc.state.submission.subreddit,
          authorViewModel:
              AuthorViewModel(author: submissionBloc.state.submission.author),
          scoreViewModel: ScoreViewModel(
            onTap: (_) => submissionBloc.add(Upvote()),
            score: submissionBloc.state.submission.score,
            voteState: submissionBloc.state.submission.voteState,
          ),
        ),
        submissionActions: SubmissionActions(
          onUpVote: () => submissionBloc.add(Upvote()),
          onDownVote: () => submissionBloc.add(Downvote()),
          onSave: (context) => submissionBloc.add(Save()),
          saved: submissionBloc.state.submission.saved,
          voteState: submissionBloc.state.submission.voteState,
        ),
      );
}

class GalleryPreviewElement extends StatelessWidget {
  final ExpandoMedia media;
  final double height;
  final Function onTap;

  GalleryPreviewElement(this.media, {@required this.height, this.onTap})
      : assert(media != null),
        assert(media is ImageMedia);

  @override
  Widget build(BuildContext context) {
    return CupertinoTappableWidget(
        onTap: onTap,
        child: (media is ImageMedia)
            ? FittedBox(
                fit: BoxFit.fill,
                child:
                    Picture(maxHeight: height, url: (media as ImageMedia).src))
            : Placeholder());
  }
}

class CupertinoTappableWidget extends StatefulWidget {
  final Function onTap;
  final Widget child;
  final StackFit fit;

  CupertinoTappableWidget(
      {this.onTap, @required this.child, this.fit = StackFit.expand});

  @override
  _CupertinoTappableWidgetState createState() =>
      _CupertinoTappableWidgetState();
}

class _CupertinoTappableWidgetState extends State<CupertinoTappableWidget> {
  _CupertinoTappableWidgetState();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: widget.fit,
      children: [
        CupertinoContextMenu(
          child: GestureDetector(onTap: widget.onTap, child: widget.child),
          actions: [
            CupertinoContextMenuAction(
              child: const Text('Action one'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class LinkPreviewWidget extends StatelessWidget {
  final String previewUrl;
  final Uri uri;
  LinkPreviewWidget({@required String link, this.previewUrl})
      : uri = Uri.parse(link);

  @override
  Widget build(BuildContext context) {
    var hostSegments = uri.host.split('.');
    final host = hostSegments[hostSegments.length - 2] +
        '.' +
        hostSegments[hostSegments.length - 1];

    return CupertinoTappableWidget(
      fit: StackFit.loose,
      onTap: null,
      child: Container(
        color: CupertinoTheme.of(context).barBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: CupertinoColors.systemGrey3.withOpacity(.3),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: FittedBox(
                          fit: BoxFit.cover, child: Image.network(previewUrl))),
                  Container(
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: '$host',
                                    style: TextStyle(
                                      color:
                                          CupertinoColors.black.withOpacity(.8),
                                    ),
                                    children: [
                                      TextSpan(
                                          text: '${uri.path}',
                                          // text: '${uri.path.substring(0, min(20, uri.path.length))}. . .',
                                          style: TextStyle(
                                            color: CupertinoColors.black
                                                .withOpacity(.3),
                                          ))
                                    ]),
                              ),
                            )),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 18,
                              color: CupertinoColors.black.withOpacity(.3),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
