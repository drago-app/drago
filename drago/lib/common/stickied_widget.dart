import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StickiedWidget extends StatelessWidget {
  final bool stickied;

  StickiedWidget(this.stickied) : assert(stickied != null);

  @override
  Widget build(BuildContext context) {
    return (stickied)
        ? Icon(
            Icons.new_releases,
            color: CupertinoColors.systemGreen,
          )
        : SizedBox.shrink();
  }
}
