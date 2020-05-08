import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helius/common/common.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'dart:math';

import 'package:helius/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';

class MediaViewerOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => CupertinoColors.black.withOpacity(1);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  // final SubmissionModel submission;
  final Bloc bloc;

  MediaViewerOverlay({@required this.bloc}) : assert(bloc != null);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return SafeArea(
      top: false,
      child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) => _buildOverlayContent(context, state)),
    );
  }

  Widget _buildOverlayContent(BuildContext context, state) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          left: 20,
          child: CupertinoButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(CupertinoIcons.add),
          ),
        ),
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
          tag: state.submission,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: state.submission.preview.thumbnailUrl,
              useOldImageOnUrlChange: true,
              placeholder: (context, url) => Center(child: LoadingIndicator()),
              errorWidget: (context, url, error) => Center(
                  child: Icon(
                CupertinoIcons.clear,
                color: CupertinoColors.destructiveRed,
              )),
              imageBuilder: (context, ImageProvider imageProvider) {
                Size size;

                // prep
                var maxWidth = MediaQuery.of(context).size.width;
                var maxHeight = MediaQuery.of(context).size.height;

                var newHeight;
                var newWidth;

                imageProvider.resolve(ImageConfiguration()).addListener(
                  ImageStreamListener(
                    (ImageInfo image, bool synchronousCall) {
                      var myImage = image.image;
                      size = Size(
                          myImage.width.toDouble(), myImage.height.toDouble());

                      var imgWidth = size.width;
                      var imgHeight = size.height;

                      // calc
                      var widthRatio = maxWidth / imgWidth;
                      var heightRatio = maxHeight / imgHeight;
                      var bestRatio = min(widthRatio, heightRatio);

                      // output
                      newWidth = imgWidth * bestRatio;
                      newHeight = imgHeight * bestRatio;
                    },
                  ),
                );
                return Container(
                  height: newHeight,
                  width: newWidth,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
