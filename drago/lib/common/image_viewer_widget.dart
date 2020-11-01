import 'package:drago/common/common.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:flutter/widgets.dart';

class ImageViewerWidget extends StatefulWidget {
  final ImageMedia media;

  ImageViewerWidget(this.media);

  @override
  State<StatefulWidget> createState() => ImageViewerWidgetState();
}

class ImageViewerWidgetState extends State<ImageViewerWidget> {
  bool captionActive = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: captionActive ? .4 : 1,
          child: Picture(
            maxHeight: MediaQuery.of(context).size.height * .8,
            url: widget.media.src,
          ),
        ),
        Positioned(
          bottom: 50,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width,
            child: ImageViewCaptionWidget(
              caption: widget.media.title,
              onTap: () {
                setState(() {
                  captionActive = !captionActive;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ImageViewCaptionWidget extends StatefulWidget {
  final String caption;
  final Function onTap;

  ImageViewCaptionWidget({this.caption, this.onTap});

  @override
  State<StatefulWidget> createState() => ImageViewCaptionWidgetState();
}

class ImageViewCaptionWidgetState extends State<ImageViewCaptionWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.caption != null
        ? Container(
            // width: MediaQuery.of(context).size.width * .8,
            child: ExpandableText(
              widget.caption,
              onTap: widget.onTap,
              trimLines: 4,
            ),
          )
        : SizedBox.shrink();
  }
}
