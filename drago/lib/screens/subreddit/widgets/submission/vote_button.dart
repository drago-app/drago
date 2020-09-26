import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SquareActionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final Color color;
  final bool switchCondition;

  SquareActionButton(
      {required this.onTap,
      required this.iconData,
      required this.color,
      required this.switchCondition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        child: (switchCondition)
            ? _ActiveSquareActionButton(
                color: color,
                iconData: iconData,
              )
            : _InactiveSquareActionButton(iconData: iconData),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (Widget child, animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      ),
    );
  }
}

class _ActiveSquareActionButton extends StatelessWidget {
  final Color color;
  final IconData iconData;

  _ActiveSquareActionButton({required this.color, required this.iconData})
      : assert(color != null),
        assert(iconData != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('value'),
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child:
            FaIcon(iconData, color: CupertinoColors.extraLightBackgroundGray),
      ),
    );
  }
}

class _InactiveSquareActionButton extends StatelessWidget {
  final IconData iconData;

  _InactiveSquareActionButton({required this.iconData})
      : assert(iconData != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('asd'),
      height: 32,
      width: 32,
      child: Center(
        child: FaIcon(iconData, color: CupertinoColors.inactiveGray),
      ),
    );
  }
}
