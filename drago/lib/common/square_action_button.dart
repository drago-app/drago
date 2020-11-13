import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SquareActionButton extends StatelessWidget {
  final Function onTap;
  final IconData iconData;
  final Color activeBackgroundColor;
  final Color inActiveBackgroundColor;
  final Color activeIconColor;
  final Color inActiveIconColor;
  final bool switchCondition;

  SquareActionButton(
      {@required this.onTap,
      @required this.iconData,
      @required this.activeBackgroundColor,
      @required this.switchCondition,
      this.inActiveBackgroundColor,
      this.activeIconColor,
      this.inActiveIconColor})
      : assert(onTap != null),
        assert(iconData != null),
        assert(activeBackgroundColor != null),
        assert(switchCondition != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        child: (switchCondition)
            ? _ActiveSquareActionButton(
                backgroundColor: activeBackgroundColor,
                iconColor: activeIconColor,
                iconData: iconData,
              )
            : _InactiveSquareActionButton(
                iconData: iconData,
                backgroundColor: inActiveBackgroundColor,
                iconColor: inActiveIconColor,
              ),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (Widget child, animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      ),
    );
  }
}

class _ActiveSquareActionButton extends StatelessWidget {
  final Color backgroundColor;
  final iconColor;
  final IconData iconData;

  _ActiveSquareActionButton(
      {@required this.backgroundColor, @required this.iconData, this.iconColor})
      : assert(backgroundColor != null),
        assert(iconData != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('value'),
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(iconData,
            color: iconColor ?? CupertinoColors.extraLightBackgroundGray),
      ),
    );
  }
}

class _InactiveSquareActionButton extends StatelessWidget {
  final Color backgroundColor;
  final iconColor;
  final IconData iconData;

  _InactiveSquareActionButton(
      {this.backgroundColor, @required this.iconData, this.iconColor})
      : assert(iconData != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('asd'),
      height: 32,
      width: 32,
      child: Center(
        child: Icon(iconData, color: iconColor ?? CupertinoColors.inactiveGray),
      ),
    );
  }
}
