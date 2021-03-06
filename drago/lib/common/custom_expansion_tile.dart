// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class CustomExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CustomExpansionTile({
    Key key,
    this.indentation = 4.0,
    this.sideBorderColor = Colors.transparent,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.body,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  final Widget body;
  final double indentation;
  final Color sideBorderColor;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    // final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slidable(
            actions: <Widget>[
              // IconSlideAction(
              //   caption: 'Archive',
              //   color: Colors.blue,
              //   icon: Icons.archive,
              //   onTap: () => null,
              // ),
              // IconSlideAction(
              //   caption: 'Share',
              //   color: Colors.indigo,
              //   icon: Icons.share,
              //   onTap: () => null,
              // ),
            ],
            actionPane: TestPane(),
            actionExtentRatio: 0.25,
            child: GestureDetector(
              onTap: () => _handleTap(),
              child: Padding(
                padding: EdgeInsets.only(right: 0, left: widget.indentation),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 3, color: widget.sideBorderColor),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.title,
                                  (!closed)
                                      ? _openWidget()
                                      : Icon(Icons.arrow_drop_down)
                                ]),
                            (!closed) ? widget.body : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // child: ListTileTheme.merge(
          //   iconColor: _iconColor.value,
          //   textColor: _headerColor.value,
          //   child: ListTile(
          //     onTap: _handleTap,
          //     leading: widget.leading,
          //     title: widget.title,
          //     subtitle: closed ? null : widget.body,
          //     trailing: widget.trailing ??
          //         RotationTransition(
          //           turns: _iconTurns,
          //           child: const Icon(Icons.expand_more),
          //         ),
          //   ),
          // ),

          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  _openWidget() =>
      (widget.trailing == null) ? Icon(Icons.arrow_drop_up) : widget.trailing;

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}

// // Copyright 2017 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// const Duration _kExpand = Duration(milliseconds: 200);

// /// A single-line [ListTile] with a trailing button that expands or collapses
// /// the tile to reveal or hide the [children].
// ///
// /// This widget is typically used with [ListView] to create an
// /// "expand / collapse" list entry. When used with scrolling widgets like
// /// [ListView], a unique [PageStorageKey] must be specified to enable the
// /// [ExpansionTile] to save and restore its expanded state when it is scrolled
// /// in and out of view.
// ///
// /// See also:
// ///
// ///  * [ListTile], useful for creating expansion tile [children] when the
// ///    expansion tile represents a sublist.
// ///  * The "Expand/collapse" section of
// ///    <https://material.io/guidelines/components/lists-controls.html>.
// class CustomExpansionTile extends StatefulWidget {
//   /// Creates a single-line [ListTile] with a trailing button that expands or collapses
//   /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
//   /// be non-null.
//   const CustomExpansionTile({
//     Key key,
//     this.indentation = 4.0,
//     this.sideBorderColor = Colors.transparent,
//     this.leading,
//     @required this.title,
//     this.backgroundColor,
//     this.onExpansionChanged,
//     this.body,
//     this.children = const <Widget>[],
//     this.trailing,
//     this.initiallyExpanded = false,
//   })  : assert(initiallyExpanded != null),
//         super(key: key);

//   /// A widget to display before the title.
//   ///
//   /// Typically a [CircleAvatar] widget.
//   final Widget leading;

//   /// The primary content of the list item.
//   ///
//   /// Typically a [Text] widget.
//   final Widget title;

//   final Widget body;
//   final double indentation;
//   final Color sideBorderColor;

//   /// Called when the tile expands or collapses.
//   ///
//   /// When the tile starts expanding, this function is called with the value
//   /// true. When the tile starts collapsing, this function is called with
//   /// the value false.
//   final ValueChanged<bool> onExpansionChanged;

//   /// The widgets that are displayed when the tile expands.
//   ///
//   /// Typically [ListTile] widgets.
//   final List<Widget> children;

//   /// The color to display behind the sublist when expanded.
//   final Color backgroundColor;

//   /// A widget to display instead of a rotating arrow icon.
//   final Widget trailing;

//   /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
//   final bool initiallyExpanded;

//   @override
//   _ExpansionTileState createState() => _ExpansionTileState();
// }

// class _ExpansionTileState extends State<CustomExpansionTile>
//     with SingleTickerProviderStateMixin {
//   static final Animatable<double> _easeOutTween =
//       CurveTween(curve: Curves.easeOut);
//   static final Animatable<double> _easeInTween =
//       CurveTween(curve: Curves.easeIn);
//   static final Animatable<double> _halfTween =
//       Tween<double>(begin: 0.0, end: 0.5);

//   final ColorTween _borderColorTween = ColorTween();
//   final ColorTween _headerColorTween = ColorTween();
//   final ColorTween _iconColorTween = ColorTween();
//   final ColorTween _backgroundColorTween = ColorTween();

//   AnimationController _controller;
//   Animation<double> _iconTurns;
//   Animation<double> _heightFactor;
//   Animation<Color> _borderColor;
//   Animation<Color> _headerColor;
//   Animation<Color> _iconColor;
//   Animation<Color> _backgroundColor;

//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: _kExpand, vsync: this);
//     _heightFactor = _controller.drive(_easeInTween);
//     _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
//     _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
//     _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
//     _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
//     _backgroundColor =
//         _controller.drive(_backgroundColorTween.chain(_easeOutTween));

//     _isExpanded =
//         PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
//     if (_isExpanded) _controller.value = 1.0;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse().then<void>((void value) {
//           if (!mounted) return;
//           setState(() {
//             // Rebuild without widget.children.
//           });
//         });
//       }
//       PageStorage.of(context)?.writeState(context, _isExpanded);
//     });
//     if (widget.onExpansionChanged != null)
//       widget.onExpansionChanged(_isExpanded);
//   }

//   Widget _buildChildren(BuildContext context, Widget child) {
//     final bool closed = !_isExpanded && _controller.isDismissed;

//     // final Color borderSideColor = _borderColor.value ?? Colors.transparent;

//     return Container(
//       decoration: BoxDecoration(
//         color: _backgroundColor.value ?? Colors.transparent,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Slidable(
//             actions: <Widget>[
//               IconSlideAction(
//                 caption: 'Archive',
//                 color: Colors.blue,
//                 icon: Icons.archive,
//                 onTap: () => null,
//               ),
//               IconSlideAction(
//                 caption: 'Share',
//                 color: Colors.indigo,
//                 icon: Icons.share,
//                 onTap: () => null,
//               ),
//             ],
//             actionPane: TestPane(),
//             actionExtentRatio: 0.25,
//             child: Material(
//               color: widget.backgroundColor,
//               child: InkWell(
//                 splashColor: Colors.transparent,
//                 onTap: () => _handleTap(),
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 0, left: widget.indentation),
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(color: Colors.grey, width: 0),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             left: BorderSide(
//                                 width: 3, color: widget.sideBorderColor),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             left: 10,
//                             right: 10,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     widget.title,
//                                     (!closed)
//                                         ? _openWidget()
//                                         : Icon(Icons.arrow_drop_down)
//                                   ]),
//                               (!closed) ? widget.body : SizedBox.shrink()
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // child: ListTileTheme.merge(
//           //   iconColor: _iconColor.value,
//           //   textColor: _headerColor.value,
//           //   child: ListTile(
//           //     onTap: _handleTap,
//           //     leading: widget.leading,
//           //     title: widget.title,
//           //     subtitle: closed ? null : widget.body,
//           //     trailing: widget.trailing ??
//           //         RotationTransition(
//           //           turns: _iconTurns,
//           //           child: const Icon(Icons.expand_more),
//           //         ),
//           //   ),
//           // ),

//           ClipRect(
//             child: Align(
//               heightFactor: _heightFactor.value,
//               child: child,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _openWidget() =>
//       (widget.trailing == null) ? Icon(Icons.arrow_drop_up) : widget.trailing;

//   @override
//   void didChangeDependencies() {
//     final ThemeData theme = Theme.of(context);
//     _borderColorTween..end = theme.dividerColor;
//     _headerColorTween
//       ..begin = theme.textTheme.subtitle1.color
//       ..end = theme.accentColor;
//     _iconColorTween
//       ..begin = theme.unselectedWidgetColor
//       ..end = theme.accentColor;
//     _backgroundColorTween..end = widget.backgroundColor;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool closed = !_isExpanded && _controller.isDismissed;
//     return AnimatedBuilder(
//       animation: _controller.view,
//       builder: _buildChildren,
//       child: closed ? null : Column(children: widget.children),
//     );
//   }
// }
