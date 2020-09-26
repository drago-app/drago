// import 'package:flutter/cupertino.dart';

// const _HeroTag _defaultHeroTag = _HeroTag(null);

// class _HeroTag {
//   const _HeroTag(this.navigator);

//   final NavigatorState navigator;

//   // Let the Hero tag be described in tree dumps.
//   @override
//   String toString() =>
//       'Default Hero tag for Cupertino navigation bars with navigator $navigator';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     final _HeroTag otherTag = other;
//     return navigator == otherTag.navigator;
//   }

//   @override
//   int get hashCode {
//     return identityHashCode(navigator);
//   }
// }

// const _kNavBarPersistentHeight = 44.0;
// const Color _kDefaultNavBarBorderColor = Color(0x4C000000);
// const Border _kDefaultNavBarBorder = Border(
//   bottom: BorderSide(
//     color: _kDefaultNavBarBorderColor,
//     width: 0.0, // One physical pixel.
//     style: BorderStyle.solid,
//   ),
// );

// class CustomCupertinoNavigationBar extends StatefulWidget
//     implements ObstructingPreferredSizeWidget {
//   /// Creates a navigation bar in the iOS style.
//   const CustomCupertinoNavigationBar({
//     Key key,
//     this.leading,
//     this.automaticallyImplyLeading = true,
//     this.automaticallyImplyMiddle = true,
//     this.previousPageTitle,
//     this.middle,
//     this.trailing,
//     this.border = _kDefaultNavBarBorder,
//     this.backgroundColor,
//     this.padding,
//     this.actionsForegroundColor,
//     this.transitionBetweenRoutes = true,
//     this.heroTag = _defaultHeroTag,
// //

//     this.onTap,
//     this.onTapCancel,
//     this.onDoubleTap,
//     this.onLongPress,
//   })  : assert(automaticallyImplyLeading != null),
//         assert(automaticallyImplyMiddle != null),
//         assert(transitionBetweenRoutes != null),
//         assert(
//             heroTag != null,
//             'heroTag cannot be null. Use transitionBetweenRoutes = false to '
//             'disable Hero transition on this navigation bar.'),
//         assert(
//             !transitionBetweenRoutes || identical(heroTag, _defaultHeroTag),
//             'Cannot specify a heroTag override if this navigation bar does not '
//             'transition due to transitionBetweenRoutes = false.'),
//         super(key: key);

//   /// parameters for the navbar
//   final Widget leading;
//   final bool automaticallyImplyLeading;
//   final bool automaticallyImplyMiddle;
//   final String previousPageTitle;
//   final Widget middle;
//   final Widget trailing;
//   final Color backgroundColor;
//   final EdgeInsetsDirectional padding;
//   final Border border;
//   @Deprecated('Use CupertinoTheme and primaryColor to propagate color')
//   final Color actionsForegroundColor;
//   final bool transitionBetweenRoutes;
//   final Object heroTag;

//   /// parameters for the underlying gesture detecor
//   final VoidCallback onTap;
//   final VoidCallback onTapCancel;
//   final VoidCallback onDoubleTap;
//   final VoidCallback onLongPress;

//   @override
//   bool get fullObstruction =>
//       backgroundColor == null ? null : backgroundColor.alpha == 0xFF;

//   @override
//   Size get preferredSize {
//     return const Size.fromHeight(_kNavBarPersistentHeight);
//   }

//   @override
//   _CustomCupertinoNavigationBarState createState() {
//     return _CustomCupertinoNavigationBarState();
//   }

//   @override
//   bool shouldFullyObstruct(BuildContext context) {
//     // TODO: implement shouldFullyObstruct
//     return null;
//   }
// }

// // A state class exists for the nav bar so that the keys of its sub-components
// // don't change when rebuilding the nav bar, causing the sub-components to
// // lose their own states.
// class _CustomCupertinoNavigationBarState
//     extends State<CustomCupertinoNavigationBar> {
//   // _NavigationBarStaticComponentsKeys keys;

//   @override
//   void initState() {
//     super.initState();
//     // keys = _NavigationBarStaticComponentsKeys();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // onTapDown: widget.onTapDown,
//       // onTapUp: widget.onTapUp,
//       onTap: widget.onTap,
//       onTapCancel: widget.onTapCancel,
//       onDoubleTap: widget.onDoubleTap,
//       onLongPress: widget.onLongPress,
//       // onLongPressStart: widget.onLongPressStart,
//       // onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
//       // onLongPressUp: widget.onLongPressUp,
//       // onLongPressEnd: widget.onLongPressEnd,
//       child: CupertinoNavigationBar(
//         leading: widget.leading,
//         middle: widget.middle,
//         trailing: widget.trailing,
//         previousPageTitle: widget.previousPageTitle,
//       ),
//     );
//   }
// }
