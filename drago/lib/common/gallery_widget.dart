import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'common.dart';

class GalleryWidget extends StatelessWidget {
  final PageController controller;
  final GalleryMedia media;

  GalleryWidget({@required this.media, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView(
          controller: controller,
          children: media.src
              .map<Widget>((src) => Center(
                    child: GalleryMediaWidget(
                      media: src,
                    ),
                  ))
              .toList()),
    );
  }
}

class GalleryMediaWidget extends StatefulWidget {
  final ExpandoMedia media;

  GalleryMediaWidget({
    @required this.media,
  }) : assert(media != null);

  @override
  State<StatefulWidget> createState() => GalleryMediaWidgetState();
}

class GalleryMediaWidgetState extends State<GalleryMediaWidget>
    implements MediaVisitor {
  @override
  Widget build(BuildContext context) {
    return widget.media.accept(this);
  }

  @override
  visitAudioMedia(AudioMedia media) {
    // TODO: implement visitAudioMedia
    throw UnimplementedError();
  }

  @override
  visitGalleryMedia(GalleryMedia media) {
    // TODO: implement visitGalleryMedia
    throw UnimplementedError();
  }

  @override
  visitGenericMedia(GenericaMedia media) {
    // TODO: implement visitGenericMedia
    throw UnimplementedError();
  }

  @override
  visitGifMedia(GifMedia media) {
    // TODO: implement visitGifMedia
    throw UnimplementedError();
  }

  @override
  visitIframeMedia(IframeMedia media) {
    // TODO: implement visitIframeMedia
    throw UnimplementedError();
  }

  @override
  visitImageMedia(ImageMedia media) => ImageViewerWidget(media);

  @override
  visitVideoMedia(VideoMedia media) {
    // TODO: implement visitVideoMedia
    throw UnimplementedError();
  }
}

class GalleryPageIndicator extends StatefulWidget {
  final num total;
  final PageController controller;

  GalleryPageIndicator({@required this.total, @required this.controller})
      : assert(controller != null),
        assert(total != null);

  @override
  State<StatefulWidget> createState() => GalleryPageIndicatorState();
}

class GalleryPageIndicatorState extends State<GalleryPageIndicator> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(current + 1).toString()} / ${widget.total.toString()}',
      style:
          defaultTextStyle.copyWith(color: CupertinoColors.white, fontSize: 18),
    );
  }

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        current = widget.controller.page.toInt();
      });
    });
    super.initState();
  }
}

class GalleryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
