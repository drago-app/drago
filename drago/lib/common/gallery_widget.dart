import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/theme.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

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
            child: GalleryCaptionWidget(
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

class GalleryCaptionWidget extends StatefulWidget {
  final String caption;
  final Function onTap;

  GalleryCaptionWidget({this.caption = '', this.onTap})
      : assert(caption != null);

  @override
  State<StatefulWidget> createState() => GalleryCaptionWidgetState();
}

class GalleryCaptionWidgetState extends State<GalleryCaptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width * .8,
        child: ExpandableText(
      widget.caption,
      onTap: widget.onTap,
      trimLines: 4,
    ));
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

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.onTap,
    this.trimLines = 4,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;
  final Function onTap;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool _readMore = true;
  bool didExceedMaxLines = false;

  void _onTapLink() {
    if (didExceedMaxLines) {
      setState(() => _readMore = !_readMore);
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetColor = CupertinoColors.white;
    TextSpan link = TextSpan(
      text: _readMore ? "... read more" : "",
      style: defaultTextStyle.copyWith(
          fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey),
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        didExceedMaxLines = textPainter.didExceedMaxLines;

        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return AnimatedSize(
        duration: Duration(milliseconds: 200),
        vsync: this,
        child: GestureDetector(onTap: _onTapLink, child: result));
  }
}
