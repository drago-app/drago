import 'package:flutter/cupertino.dart';

class FlairWidget extends StatelessWidget {
  final String flairText;

  FlairWidget({@required this.flairText}) : assert(flairText != null);

  @override
  Widget build(BuildContext context) {
    return (flairText == '')
        ? SizedBox.shrink()
        : Container(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Text(flairText, style: TextStyle(fontSize: 12)),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: CupertinoColors.lightBackgroundGray));
  }
}

class NSFWFlairWidget extends StatelessWidget {
  final bool nsfw;

  const NSFWFlairWidget(this.nsfw);

  @override
  Widget build(BuildContext context) {
    return (!nsfw)
        ? SizedBox.shrink()
        : Container(
            child: Padding(
              padding: EdgeInsets.all(4),
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
