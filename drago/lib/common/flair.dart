

import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';

class FlairWidget extends StatelessWidget {
  final String flairText;
  final TextStyle? style;
  final color;
  static final _defaultColor = CupertinoColors.lightBackgroundGray;

  FlairWidget({required this.flairText, this.style, this.color})
      : assert(flairText != null);

  @override
  Widget build(BuildContext context) {
    return (flairText == '')
        ? SizedBox.shrink()
        : Container(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(flairText,
                  style: defaultTextStyle.copyWith(fontSize: 12).merge(style)),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color ?? _defaultColor));
  }
}

class NSFWFlairWidget extends StatelessWidget {
  final bool? nsfw;

  const NSFWFlairWidget(this.nsfw);

  @override
  Widget build(BuildContext context) {
    return (!nsfw!)
        ? SizedBox.shrink()
        : Container(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(
                'NSFW',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.white,
                  letterSpacing: .1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: CupertinoColors.systemRed));
  }
}
