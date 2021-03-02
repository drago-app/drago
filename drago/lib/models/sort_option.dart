import 'package:dartz/dartz.dart';
import 'package:drago/blocs/subreddit_page_bloc/subreddit_page.dart';
import 'package:drago/icons_enum.dart';
import 'package:equatable/equatable.dart';

enum SubmissionSortType { hot, top, controversial, newest, rising }
enum TimeFilter_ { all, day, hour, month, week, year }

class SubmissionSort extends Equatable {
  final DragoIcons icon;
  final String _baseDescription;
  final SubmissionSortType type;
  final Option<SubmissionFilter> selectedFilter;
  // final Option<List<SubmissionFilter>> filtersOptions;

  String get description => selectedFilter.fold(() => _baseDescription,
      (filter) => '$_baseDescription (${filter.description})');

  const SubmissionSort(
    this.icon,
    this._baseDescription,
    this.type, {
    this.selectedFilter = const None(),
  });

  @override
  List<Object> get props => [type];

  SubmissionSort copyWith({Option<SubmissionFilter> selectedFilter}) {
    return SubmissionSort(
      icon,
      _baseDescription,
      type,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class SubmissionFilter extends Equatable {
  final DragoIcons icon;
  final String description;
  final TimeFilter_ type;
  final bool selected;

  const SubmissionFilter(this.icon, this.description, this.type,
      {this.selected = false});

  @override
  List<Object> get props => [type];

  SubmissionFilter copyWith({selected}) {
    return SubmissionFilter(icon, description, type,
        selected: selected ?? this.selected);
  }
}

final hotSubmissionSort =
    SubmissionSort(DragoIcons.sort_hot, "Hot", SubmissionSortType.hot);
final newestSubmissionSort =
    SubmissionSort(DragoIcons.sort_newest, "Newest", SubmissionSortType.newest);
final risingSubmissionSort =
    SubmissionSort(DragoIcons.sort_rising, "Rising", SubmissionSortType.rising);
final topSubmissionSort = SubmissionSort(
  DragoIcons.sort_top,
  "Top",
  SubmissionSortType.top,
  // filtersOptions: Some(filters.values.toList()),
);
final controversialSubmissionSort = SubmissionSort(
  DragoIcons.sort_controversial,
  "Controversial",
  SubmissionSortType.controversial,
  // filtersOptions: Some(filters.values.toList()),
);
const filters = [
  hourFilter,
  dayFilter,
  weekFilter,
  monthFilter,
  yearFilter,
  allFilter
];

// const filters = {
//   TimeFilter_.hour: hourFilter,
//   TimeFilter_.day: dayFilter,
//   TimeFilter_.week: weekFilter,
//   TimeFilter_.month: monthFilter,
//   TimeFilter_.year: yearFilter,
//   TimeFilter_.all: allFilter
// };

const hourFilter = const SubmissionFilter(
    DragoIcons.time_filter_hour, 'Hour', TimeFilter_.hour);
const dayFilter =
    const SubmissionFilter(DragoIcons.time_filter_day, 'Day', TimeFilter_.day);
const weekFilter = const SubmissionFilter(
    DragoIcons.time_filter_week, 'Week', TimeFilter_.week);
const monthFilter = const SubmissionFilter(
    DragoIcons.time_filter_month, 'Month', TimeFilter_.month);
const yearFilter = const SubmissionFilter(
    DragoIcons.time_filter_year, 'Year', TimeFilter_.year);
const allFilter =
    const SubmissionFilter(DragoIcons.time_filter_all, 'All', TimeFilter_.all);
