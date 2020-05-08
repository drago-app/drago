import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helius/core/entities/submission_entity.dart';

class VoteButton extends StatelessWidget {
  final Function onTap;
  final IconData iconData;
  final Color color;
  final bool switchCondition;

  VoteButton(
      {@required this.onTap,
      @required this.iconData,
      @required this.color,
      @required this.switchCondition})
      : assert(onTap != null),
        assert(iconData != null),
        assert(color != null),
        assert(switchCondition != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        child: (switchCondition)
            ? ActiveVoteState(
                color: color,
                iconData: iconData,
              )
            : NeutralVoteState(iconData: iconData),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (Widget child, animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      ),
    );
  }
}

class ActiveVoteState extends StatelessWidget {
  final Color color;
  final IconData iconData;

  ActiveVoteState({@required this.color, @required this.iconData})
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child:
            FaIcon(iconData, color: CupertinoColors.extraLightBackgroundGray),
      ),
    );
  }
}

class NeutralVoteState extends StatelessWidget {
  final IconData iconData;

  NeutralVoteState({@required this.iconData}) : assert(iconData != null);

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
