// import 'package:flutter/cupertino.dart';
// import 'package:helius/styles.dart';



// class ListItemBase extends StatelessWidget {
//   final bool lastItem;
//   static const double _safeAreaLeft = 16.0;
//   static const double _safeAreaTop = 8.0;
//   static const double _safeAreaRight = 8.0;
//   static const double _safeAreaBottom = 8.0;
//   static const double _middlePadding = 12;
//   final List<Widget> middle;
//   final ListItemLeading leading;
//   final Widget trailing;

//   const ListItemBase(
//       {this.lastItem = false,
//       @required this.middle,
//       this.leading,
//       this.trailing});

//   @override
//   Widget build(BuildContext build) {
//     return (lastItem)
//         ? _row(
//             leading: this.leading, middle: this.middle, trailing: this.trailing)
//         : _rowWithDivider(
//             row: _row(
//                 leading: this.leading,
//                 middle: this.middle,
//                 trailing: this.trailing),
//             divider: _divider());
//   }

//   Widget _middle(List<Widget> items) {
//     return Expanded(
//       child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: _middlePadding),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: items,
//           )),
//     );
//   }

//   Widget _row({leading, middle, trailing}) {
//     return SafeArea(
//       top: false,
//       bottom: false,
//       minimum: const EdgeInsets.only(
//         left: _safeAreaLeft,
//         top: _safeAreaTop,
//         bottom: _safeAreaBottom,
//         right: _safeAreaRight,
//       ),
//       child: Row(
//         children: <Widget>[
//           (leading == null) ? SizedBox.shrink() : leading,
//           _middle(middle),
//           (trailing == null) ? SizedBox.shrink() : trailing,
//         ],
//       ),
//     );
//   }

//   Widget _rowWithDivider({row, divider}) {
//     return Column(
//       children: <Widget>[row, _divider()],
//     );
//   }

//   Widget _divider() {
//     return Padding(
//         padding: EdgeInsets.only(
//           left: _dividerPadding(),
//           right: 16,
//         ),
//         child: Container(height: 1, color: Styles.productRowDivider));
//   }

//   double _dividerPadding() {
//     return _middlePadding +
//         _safeAreaLeft +
//         ((this.leading == null) ? 0 : leading.height);
//   }
// }

// class ListItemLeading extends StatelessWidget {
//   final double height;
//   final double width;
//   final Widget child;

//   ListItemLeading(
//       {@required this.height, @required this.width, @required this.child})
//       : assert(height > 0),
//         assert(width > 0);

//   @override
//   Widget build(BuildContext context) => child;
// }
