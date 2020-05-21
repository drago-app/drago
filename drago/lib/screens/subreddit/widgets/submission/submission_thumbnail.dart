import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/common/common.dart';
import 'package:drago/core/entities/preview.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/screens/subreddit/widgets/media_viewer/widgets.dart';

class _DefaultThumbnail extends StatelessWidget {
  final SubmissionModel submission;

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
  final SubmissionModel submission;

  _ImageThumbnail({@required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: submission,
      child: _ThumbnailBase(
          onTap: () {
            Navigator.of(context, rootNavigator: false).push(MediaViewerOverlay(
                bloc: BlocProvider.of<SubmissionBloc>(context)));
          },
          submission: submission),
    );
  }
}

class _LinkThumbnail extends StatelessWidget {
  final SubmissionModel submission;

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
  final SubmissionModel submission;

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
  final SubmissionModel submission;

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
  final SubmissionModel submission;
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
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: submission.preview.thumbnailUrl,
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
                  height: 64,
                  width: 64,
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
      bottom: 5,
      right: 5,
      child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.play,
              color: CupertinoColors.darkBackgroundGray,
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
      bottom: 5,
      right: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
        decoration: BoxDecoration(
            color: CupertinoColors.lightBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
          child: Text(
            "GIF",
            style: TextStyle(fontWeight: FontWeight.w600),
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
  final SubmissionModel submission;
  const SubmissionThumbnail({@required this.submission});

  @override
  Widget build(BuildContext context) {
    if (submission.preview.sourceType == ImageSourceType.LINK) {
      return _LinkThumbnail(
        submission: submission,
      );
    } else if (submission.preview.sourceType == ImageSourceType.GIF) {
      return _GifThumbnail(
        submission: submission,
      );
    } else if (submission.preview.sourceType == ImageSourceType.VIDEO) {
      return _VideoThumbnail(
        submission: submission,
      );
    } else if (submission.preview.sourceType == ImageSourceType.IMAGE) {
      return _ImageThumbnail(submission: submission);
    } else {
      return _DefaultThumbnail(submission: submission);
    }
  }
}
