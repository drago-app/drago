import 'package:drago/icons_enum.dart';
import 'package:flutter/cupertino.dart';

class ToastWidget extends StatelessWidget {
  final String message;
  final Color color;
  final DragoIcons icon;

  const ToastWidget({Key key, @required this.message, this.color, this.icon})
      : super(key: key);

  factory ToastWidget.warning(String message) => ToastWidget(
        message: message,
        color: CupertinoColors.activeOrange,
        icon: DragoIcons.clear,
      );

  factory ToastWidget.success(String message) => ToastWidget(
        message: message,
        color: CupertinoColors.activeGreen,
        icon: DragoIcons.check,
      );

  factory ToastWidget.info(String message) => ToastWidget(
        message: message,
        color: CupertinoColors.activeBlue,
        icon: DragoIcons.check,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: CupertinoColors.activeOrange,
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.white,
                    textBaseline: TextBaseline.alphabetic),
                children: [
                  WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Icon(getIconData(icon),
                          size: 18, color: CupertinoColors.white)),
                  TextSpan(
                    text: " $message",
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
