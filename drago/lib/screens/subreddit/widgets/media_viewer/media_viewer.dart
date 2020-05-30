// import 'package:drago/common/picture.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:drago/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';

// class HeroDialogRoute<T> extends PageRoute<T> {
//   HeroDialogRoute({this.builder}) : super();

//   final WidgetBuilder builder;

//   @override
//   bool get opaque => true;

//   @override
//   bool get barrierDismissible => true;

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);

//   @override
//   bool get maintainState => true;

//   @override
//   Color get barrierColor => CupertinoColors.black.withOpacity(1);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return const DragDownToPopPageTransitionsBuilder(
//             backgroundColor: CupertinoColors.black)
//         .buildTransitions(this, context, animation, secondaryAnimation, child);

//     // return FadeTransition(
//     //   opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
//     //   child: child,
//     // );
//   }

//   @override
//   dispose() {
//     SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

//     return builder(context);
//   }

//   @override
//   String get barrierLabel => null;
// }

// class ImageViewerPageRoute extends PageRoute<void> {
//   final WidgetBuilder builder;
//   ImageViewerPageRoute({@required this.builder});
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return const DragDownToPopPageTransitionsBuilder(
//             backgroundColor: CupertinoColors.black)
//         .buildTransitions(this, context, animation, secondaryAnimation, child);
//   }

//   @override
//   Color get barrierColor => CupertinoColors.black;

//   @override
//   bool get barrierDismissible => false;

//   @override
//   String get barrierLabel => null;

//   @override
//   Widget buildPage(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//     final Widget child = builder(context);
//     return child;
//   }

//   @override
//   bool get maintainState => true;

//   @override
//   bool get opaque => false;

//   @override
//   Duration get transitionDuration => Duration(milliseconds: 1000);
// }
