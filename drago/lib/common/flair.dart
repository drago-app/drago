import 'package:flutter/cupertino.dart';

class FlairWidget extends StatelessWidget {
  final String flairText;

  FlairWidget({required this.flairText}) : assert(flairText != null);

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
