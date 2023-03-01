

import 'package:drago/blocs/submission_bloc.dart/submission_bloc.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/screens/subreddit/widgets/submission/submission.dart';
import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'common.dart';

class GalleryWidget extends StatelessWidget {
  final PageController controller;
  final GalleryMedia media;
  final SubmissionBloc? bloc;
  final startingIndex;

  GalleryWidget(
      {required this.media, required this.bloc, this.startingIndex = 0})
      : controller = PageController(initialPage: startingIndex);

  @override
  Widget build(BuildContext context) {
    return SecondPage(
      topRightCorner: GalleryPageIndicator(
        controller: controller,
        total: media.size,
        initialIndex: startingIndex,
      ),
      body:
          Center(child: GalleryPageView(controller: controller, media: media)),
      bloc: bloc,
    );
  }
}

class GalleryPageView extends StatelessWidget {
  final PageController controller;
  final GalleryMedia media;

  GalleryPageView({required this.media, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView(
          controller: controller,
          children: media.src!
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
    required this.media,
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
  final initialIndex;

  GalleryPageIndicator(
      {required this.total, required this.controller, this.initialIndex = 0})
      : assert(controller != null),
        assert(total != null);

  @override
  State<StatefulWidget> createState() => GalleryPageIndicatorState();
}

class GalleryPageIndicatorState extends State<GalleryPageIndicator> {
  late var index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    widget.controller.addListener(() {
      setState(() {
        index = widget.controller.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(index + 1).toString()} / ${widget.total.toString()}',
      style:
          defaultTextStyle.copyWith(color: CupertinoColors.white, fontSize: 18),
    );
  }

  // @override
  // void initState() {
  //   widget.controller.addListener(() {
  //     setState(() {
  //       current = widget.controller.page.toInt();
  //     });
  //   });
  //   super.initState();
  // }
}

class GalleryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
