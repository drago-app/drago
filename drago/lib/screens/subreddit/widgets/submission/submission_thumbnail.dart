import 'package:cached_network_image/cached_network_image.dart';
import 'package:drago/common/drag_to_pop_modal/drag_to_pop_modal.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/common/common.dart';
import 'package:drago/core/entities/preview.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoThumbnailLabel extends StatelessWidget {
  const VideoThumbnailLabel();

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
  final String previewUrl;
  final Widget label;
  final Function onTap;

  SubmissionThumbnail(
      {this.previewUrl, this.label = const SizedBox.shrink(), this.onTap});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                );
              },
            ),
          ),
          label
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final Bloc bloc;
  final Widget body;
  final Widget topRightCorner;

  SecondPage(
      {@required this.bloc,
      @required this.body,
      this.topRightCorner = const SizedBox.shrink()});

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
          Hero(
              transitionOnUserGestures: true,
              tag: state.submission.previewUrl,
              child: body),
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
          Positioned(top: 40, right: 40, child: topRightCorner)
        ],
      ),
    );
  }
}
