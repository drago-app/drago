

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'page_transition.dart';

class DragToPopPageRoute<T> extends PageRoute<T> {
  DragToPopPageRoute({this.builder}) : super();

  final WidgetBuilder? builder;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => CupertinoColors.black.withOpacity(1);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return const DragDownToPopPageTransitionsBuilder(
            backgroundColor: CupertinoColors.black)
        .buildTransitions(this, context, animation, secondaryAnimation, child);

    // return FadeTransition(
    //   opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    //   child: child,
    // );
  }

  @override
  dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return builder!(context);
  }

  @override
  String? get barrierLabel => null;
}
