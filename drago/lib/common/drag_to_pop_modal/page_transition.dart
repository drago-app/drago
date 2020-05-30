import 'package:flutter/animation.dart' show Curves;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'pop_gesture_helper.dart';

/// A builder that builds a background widget given a child.
typedef TransitionBackgroundBuilder = Widget Function(
    BuildContext context, Widget child);

class DragDownToPopPageTransitionsBuilder extends PageTransitionsBuilder {
  const DragDownToPopPageTransitionsBuilder({
    this.backgroundColor,
    this.backgroundBuilder,
  });

  final Color backgroundColor;
  final TransitionBackgroundBuilder backgroundBuilder;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideAndFadeTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: PopGestureHelper.isPopGestureInProgress(route),
      child: PopGestureHelper.buildPopGestureDetector(route, child),
      backgroundColor: backgroundColor,
      backgroundBuilder: backgroundBuilder,
    );
  }
}

class SlideAndFadeTransition extends StatelessWidget {
  SlideAndFadeTransition({
    Key key,
    @required Animation<double> primaryRouteAnimation,
    @required Animation<double> secondaryRouteAnimation,
    @required bool linearTransition,
    @required this.child,
    Color backgroundColor,
    TransitionBackgroundBuilder backgroundBuilder,
  })  : assert(linearTransition != null),
        _primaryAnimation1 = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                  ))
            .drive(Tween<double>(
          begin: 0.0,
          end: 1.0,
        )),
        // _primaryAnimation2 = (linearTransition
        //         ? primaryRouteAnimation
        //         : CurvedAnimation(
        //             parent: primaryRouteAnimation,
        //             curve: Curves.linearToEaseOut,
        //           ))
        //     .drive(Tween<Offset>(
        //   begin: Offset(0.0, 0.1),
        //   end: Offset(0.0, 0.0),
        // )),
        _backgroundBuilder = (backgroundBuilder ??
            (context, child) => DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.white,
                  ),
                  child: child,
                )),
        super(key: key);

  final Animation<double> _primaryAnimation1;
  // final Animation<Offset> _primaryAnimation2;

  final TransitionBackgroundBuilder _backgroundBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    return FadeTransition(
      opacity: _primaryAnimation1,
      child: _backgroundBuilder(
        context,
        child,
      ),
    );
  }
}
