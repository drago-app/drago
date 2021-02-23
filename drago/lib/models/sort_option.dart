import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SubmissionSortType { hot, top, controversial, newest, rising }
enum TimeFilter_ { all, day, hour, month, week, year }

// class TimeFilterOption extends Equatable {
//   final TimeFilter_ filter;
//   final IconData iconData;
//   final String label;

//   TimeFilterOption(this.filter, this.iconData, this.label);

//   factory TimeFilterOption.factory(TimeFilter_ filter) {
//     switch (filter) {
//       case TimeFilter_.day:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));

//       case TimeFilter_.hour:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));

//       case TimeFilter_.month:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));

//       case TimeFilter_.week:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));

//       case TimeFilter_.year:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));
//       case TimeFilter_.all:
//       default:
//         return TimeFilterOption(filter, FontAwesomeIcons.clock,
//             SortUtils.timeFilterToString(filter));
//     }
//   }

//   @override
//   List<Object> get props => [filter, iconData, label];
// }

// class SortUtils {
//   static String timeFilterToString(TimeFilter_ filter) {
//     switch (filter) {
//       case TimeFilter_.all:
//         return 'All';
//       case TimeFilter_.day:
//         return 'Day';
//       case TimeFilter_.hour:
//         return 'Hour';
//       case TimeFilter_.month:
//         return 'Month';
//       case TimeFilter_.week:
//         return 'Week';
//       case TimeFilter_.year:
//         return 'Year';
//       default:
//         return '???';
//     }
//   }

//   static isFilterable(SubmissionSortType type) {
//     switch (type) {
//       case SubmissionSortType.top:
//       case SubmissionSortType.controversial:
//         {
//           return true;
//         }
//       default:
//         return false;
//     }
//   }
// }

// class SubmissionSortOption extends Equatable {
//   final IconData icon;
//   final bool selected;
//   final SubmissionSortType type;
//   final String label;
//   final bool filterable;

//   SubmissionSortOption(
//       {@required this.icon,
//       @required this.selected,
//       @required this.type,
//       @required this.label,
//       this.filterable = false});

//   factory SubmissionSortOption.factory({@required type, selected = false}) {
//     switch (type) {
//       case SubmissionSortType.hot:
//         {
//           return SubmissionSortOption(
//               icon: FontAwesomeIcons.fireAlt,
//               selected: selected,
//               label: 'Hot',
//               type: type);
//         }
//       case SubmissionSortType.top:
//         {
//           return SubmissionSortOption(
//               filterable: true,
//               icon: FontAwesomeIcons.thumbsUp,
//               selected: selected,
//               label: 'Top',
//               type: type);
//         }
//       case SubmissionSortType.rising:
//         {
//           return SubmissionSortOption(
//               icon: FontAwesomeIcons.chartLine,
//               selected: selected,
//               label: 'Rising',
//               type: type);
//         }
//       case SubmissionSortType.controversial:
//         {
//           return SubmissionSortOption(
//               filterable: true,
//               icon: FontAwesomeIcons.bomb,
//               selected: selected,
//               label: 'Controversial',
//               type: type);
//         }
//       case SubmissionSortType.newest:
//         {
//           return SubmissionSortOption(
//               icon: FontAwesomeIcons.clock,
//               selected: selected,
//               label: 'Newest',
//               type: type);
//         }
//       default:
//         {
//           return SubmissionSortOption(
//               icon: FontAwesomeIcons.fireAlt,
//               selected: selected,
//               label: 'Default',
//               type: type);
//         }
//     }
//   }

//   @override
//   List<Object> get props => [icon, selected, type, label];
//   SubmissionSortOption copyWith({selected}) {
//     return SubmissionSortOption(
//         icon: this.icon,
//         type: this.type,
//         label: this.label,
//         selected: selected ?? this.selected);
//   }
// }
