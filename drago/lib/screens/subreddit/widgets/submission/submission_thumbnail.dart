import 'package:cached_network_image/cached_network_image.dart';
import 'package:drago/common/drag_to_pop_modal/drag_to_pop_modal.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/common/common.dart';
import 'package:drago/core/entities/preview.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_reddit_links.dart';

class _DefaultThumbnail extends StatelessWidget {
  final Submission submission;

  _DefaultThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return _ThumbnailBase(
      onTap: () => null,
      submission: submission,
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final Submission submission;

  _ImageThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: submission.previewUrl,
      child: _ThumbnailBase(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              DragToPopPageRoute(
                builder: (modalcontext) => SecondPage(
                  bloc: context.bloc<SubmissionBloc>(),
                ),
              ),
            );
          },
          submission: submission),
    );
  }
}

class _LinkThumbnail extends StatelessWidget {
  final Submission submission;

  _LinkThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return _ThumbnailBase(
        onTap: () => null,
        thumbnailLabel: const _LinkThumbnailLabel(),
        submission: submission);
  }
}

class _VideoThumbnail extends StatelessWidget {
  final Submission submission;

  _VideoThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return _ThumbnailBase(
        onTap: () => null,
        thumbnailLabel: const _VideoThumbnailLabel(),
        submission: submission);
  }
}

class _GifThumbnail extends StatelessWidget {
  final Submission submission;

  _GifThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return _ThumbnailBase(
        onTap: () => null,
        thumbnailLabel: const _GifThumbnailLabel(),
        submission: submission);
  }
}

class _ThumbnailBase extends StatelessWidget {
  final Widget thumbnailLabel;
  final Submission submission;
  final Function onTap;

  _ThumbnailBase(
      {this.thumbnailLabel, @required this.submission, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: CachedNetworkImage(
              imageUrl: submission.previewUrl,
              useOldImageOnUrlChange: true,
              placeholder: (context, submission) =>
                  Center(child: LoadingIndicator()),
              errorWidget: (context, submission, error) => Center(
                  child: Icon(
                CupertinoIcons.clear,
                color: CupertinoColors.destructiveRed,
              )),
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                );
              },
            ),
          ),
          thumbnailLabel ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _VideoThumbnailLabel extends StatelessWidget {
  const _VideoThumbnailLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 2,
      right: 2,
      child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.play,
              color: CupertinoColors.darkBackgroundGray.withOpacity(.8),
              size: 10,
            ),
          )),
    );
  }
}

class _GifThumbnailLabel extends StatelessWidget {
  const _GifThumbnailLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 2,
      right: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
        decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            "GIF",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class _LinkThumbnailLabel extends StatelessWidget {
  const _LinkThumbnailLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 5,
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.solidCompass,
            color: CupertinoColors.lightBackgroundGray,
            size: 25,
          ),
        ),
      ),
    );
  }
}

class SubmissionThumbnail extends StatelessWidget {
  final Submission submission;
  const SubmissionThumbnail({@required this.submission});

  @override
  Widget build(BuildContext context) {
    return _ImageThumbnail(
      submission: submission,
    );
    // if (submission.preview.sourceType == ImageSourceType.LINK) {
    //   return _LinkThumbnail(
    //     submission: submission,
    //   );
    // } else if (submission.preview.sourceType == ImageSourceType.GIF) {
    //   return _GifThumbnail(
    //     submission: submission,
    //   );
    // } else if (submission.preview.sourceType == ImageSourceType.VIDEO) {
    //   return _VideoThumbnail(
    //     submission: submission,
    //   );
    // } else if (submission.preview.sourceType == ImageSourceType.IMAGE) {
    //   return _ImageThumbnail(submission: submission);
    // } else {
    //   return _DefaultThumbnail(submission: submission);
    // }
  }
}

class SecondPage extends StatelessWidget {
  final Bloc bloc;

  SecondPage({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: bloc,
        builder: (context, state) => _buildOverlayContent(context, state));
  }

  Widget _buildOverlayContent(BuildContext context, state) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MediaViewerBottomRow(
                submission: state.redditLink,
                bloc: bloc,
              ),
            ),
          ),
          Hero(
            transitionOnUserGestures: true,
            tag: state.redditLink.previewUrl,
            child: Picture(
                maxHeight: MediaQuery.of(context).size.height,
                url: state.redditLink.previewUrl),
          ),
          Align(
            alignment: Alignment.topLeft,
            // top: -15,
            // left: 10,
            child: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(
                CupertinoIcons.clear,
                size: 50,
                color: CupertinoColors.lightBackgroundGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
