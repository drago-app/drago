import 'package:flutter/cupertino.dart';

class TappableIconTextSpan extends StatelessWidget {
  final Function onTap;
  final Icon icon;
  final String text;
  final TextStyle style;
  final color;

  const TappableIconTextSpan(
      {Key key,
      this.onTap,
      @required this.icon,
      @required this.text,
      this.color,
      this.style = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
            style: TextStyle(
                    fontSize: 14,
                    color: color ?? CupertinoColors.systemGrey,
                    textBaseline: TextBaseline.alphabetic)
                .merge(style),
            children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: icon),
              TextSpan(
                text: text,
              )
            ]),
      ),
    );
  }
}
