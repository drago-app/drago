import 'package:cached_network_image/cached_network_image.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:drago/blocs/submission_bloc.dart/submission.dart';

class VideoThumbnailLabel extends StatelessWidget {
  const VideoThumbnailLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 2,
      right: 2,
      child: Icon(
        CupertinoIcons.arrowtriangle_right_circle_fill,
        color: CupertinoColors.extraLightBackgroundGray,
        size: 25,
      ),
    );
  }
}

class GifThumbnailLabel extends StatelessWidget {
  const GifThumbnailLabel();

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

class GalleryThumbnailLabel extends StatelessWidget {
  final GalleryMedia galleryMedia;

  const GalleryThumbnailLabel(this.galleryMedia);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
        decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            "${galleryMedia.size ?? 0}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class LinkThumbnailLabel extends StatelessWidget {
  const LinkThumbnailLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 2,
        right: 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 15,
              width: 15,
              color: CupertinoColors.darkBackgroundGray,
            ),
            Icon(
              CupertinoIcons.compass_fill,
              color: CupertinoColors.systemBackground,
              size: 25,
            ),
          ],
        ));
  }
}

class SubmissionThumbnail extends StatelessWidget {
  final String previewUrl;
  final Widget label;
  final Function onTap;
  final String heroTag;

  SubmissionThumbnail(
      {this.previewUrl,
      this.label = const SizedBox.shrink(),
      this.onTap,
      @required this.heroTag});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                fadeInDuration: Duration(),
                imageUrl: previewUrl,
                useOldImageOnUrlChange: true,
                placeholder: (context, submission) => Container(
                  height: 55,
                  width: 55,
                  color: CupertinoColors.inactiveGray,
                ),
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
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill),
                    ),
                  );
                },
              ),
            ),
            label
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final Bloc bloc;
  final Widget body;
  final Widget topRightCorner;
  final Widget caption;

  SecondPage(
      {@required this.bloc,
      @required this.body,
      this.topRightCorner = const SizedBox.shrink(),
      this.caption = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: bloc,
        builder: (context, state) => _buildOverlayContent(context, state));
  }

  Widget _buildOverlayContent(BuildContext context, SubmissionState state) {
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
                submission: state.submission,
                bloc: bloc,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
                transitionOnUserGestures: true,
                tag: state.submission.url,
                child: body),
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
          Positioned(top: 40, right: 40, child: topRightCorner),
          Align(
            alignment: Alignment.bottomCenter,
            child: caption,
          )
        ],
      ),
    );
  }
}
