

import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    this.onTap,
    this.trimLines = 4,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;
  final Function? onTap;

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
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetColor = CupertinoColors.white;
    TextSpan link = TextSpan(
      text: _readMore ? "...read more" : "",
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
        int? endIndex;
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
