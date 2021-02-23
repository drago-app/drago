import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/icons_enum.dart';
import 'package:drago/models/sort_option.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import './subreddit_page.dart';
import 'package:rxdart/rxdart.dart';

class SubredditPageBloc extends Bloc<SubredditPageEvent, SubredditPageState> {
  final String subreddit;
  final GetRedditLinks getRedditLinks;
  final Map<SubmissionSortType, SubmissionSort> _sortOptions = {
    SubmissionSortType.hot: _hotSubmissionSort,
    SubmissionSortType.newest: _newestSubmissionSort,
    SubmissionSortType.rising: _risingSubmissionSort,
    SubmissionSortType.top: _topSubmissionSort,
    SubmissionSortType.controversial: _controversialSubmissionSort,
  };
  // final SortOptionsRepository sortOptionsRepository = SortOptionsRepository();

  SubredditPageBloc({@required this.getRedditLinks, @required this.subreddit})
      : assert(subreddit != null),
        super(
          SubredditPageInitial(
              subreddit: subreddit, currentSort: _hotSubmissionSort),
        );

  @override
  Stream<Transition<SubredditPageEvent, SubredditPageState>> transformEvents(
    Stream<SubredditPageEvent> events,
    TransitionFunction<SubredditPageEvent, SubredditPageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 0)),
      transitionFn,
    );
  }

  @override
  Stream<SubredditPageState> mapEventToState(SubredditPageEvent event) async* {
    if (event is LoadSubmissions) {
      yield* _mapLoadSubmissionsToState(event: event);
    } else if (event is LoadMore) {
      yield* _mapLoadMoreToState();
    } else if (event is UserTappedSortButton) {
      yield* _mapUserTappedSortButtonToState();
    } else if (event is UserSelectedSortOption) {
      yield* _mapUserSelectedSortOptionToState(event);
    } else if (event is UserSelectedFilterOption) {
      yield* _mapUserSelectedFilterOptionToState(event);
    }
  }

  Stream<SubredditPageState> _mapUserSelectedFilterOptionToState(
      UserSelectedFilterOption event) async* {
    final newSort = event.sort.copyWith(selectedFilter: Some(event.filter));
    yield SubredditPageLoading(
        subreddit: state.subreddit, currentSort: newSort);
    final failureOrSubmissions = await getRedditLinks(GetRedditLinksParams(
        subreddit: this.subreddit,
        filter: event.filter.type,
        sort: event.sort.type));

    yield* failureOrSubmissions.fold(
      (left) async* {
        print(left);
      },
      (redditLinks) async* {
        yield SubredditPageLoaded(
            subreddit: this.subreddit,
            redditLinks: redditLinks,
            currentSort: newSort);
      },
    );
  }

  Stream<SubredditPageState> _mapUserSelectedSortOptionToState(
      UserSelectedSortOption event) async* {
    yield* event.sort.filtersOptions.fold(() async* {
      yield* _mapLoadSubmissionsToState(
          event: LoadSubmissions(sort: event.sort.type));
    }, (options) async* {
      await Future.delayed(
        Duration(milliseconds: 200),
      );

      yield DisplayingSortOptions(
          redditLinks: state.redditLinks,
          currentSort: state.currentSort,
          subreddit: state.subreddit,
          options: options
              .map<ActionModel>(
                  (type) => createFilterAction(this, event.sort, type))
              .toList(growable: false));
    });
  }

  Stream<SubredditPageState> _mapUserTappedSortButtonToState() async* {
    yield DisplayingSortOptions(
        redditLinks: state.redditLinks,
        currentSort: state.currentSort,
        subreddit: state.subreddit,
        options: _sortOptions.values
            .map((SubmissionSort sort) =>
                sort.type == state.currentSort.type ? state.currentSort : sort)
            .map((SubmissionSort sort) => createSortAction(this, sort))
            .toList(growable: false));
  }

  Stream<SubredditPageState> _mapLoadSubmissionsToState(
      {LoadSubmissions event}) async* {
    yield SubredditPageLoading(
        subreddit: subreddit, currentSort: _sortOptions[event.sort]);

    final Either<Failure, List> failureOrSubmissions = await getRedditLinks(
        GetRedditLinksParams(
            subreddit: this.subreddit, filter: event.filter, sort: event.sort));

    yield* failureOrSubmissions.fold(
      (left) async* {
        print(left);
      },
      (submissions) async* {
        yield SubredditPageLoaded(
            subreddit: this.subreddit,
            redditLinks: (failureOrSubmissions as Right).value,
            currentSort: _sortOptions[event.sort]);
      },
    );
  }

  Stream<SubredditPageState> _mapLoadMoreToState() async* {
    if (state is SubredditPageLoaded) {
      final s = state as SubredditPageLoaded;
      final lastSubmission = s.redditLinks.last;
      final failureOrSubmissions = await getRedditLinks(GetRedditLinksParams(
          sort: state.currentSort.type,
          subreddit: this.subreddit,
          after: lastSubmission.id));

      yield* failureOrSubmissions.fold((left) async* {
        print(left.message);
      }, (right) async* {
        yield s.copyWith(redditLinks: s.redditLinks + right);
      });
    }
  }
}

final createFilterAction =
    (SubredditPageBloc bloc, SubmissionSort sort, SubmissionFilter filter) =>
        ActionModel(
          () {
            bloc.add(UserSelectedFilterOption(sort: sort, filter: filter));
          },
          filter.icon,
          filter.description,
        );

final createSortAction = (SubredditPageBloc bloc, SubmissionSort sort) =>
    ActionModel(() {
      bloc.add(UserSelectedSortOption(sort: sort));
    }, sort.icon, sort.description,
        selected: bloc.state.currentSort.type == sort.type,
        hasOptions: sort.filtersOptions.fold(() => false, (some) => true));

class ActionModel extends Equatable {
  final Function action;
  final String description;
  final DragoIcons icon;
  final bool selected;
  final bool hasOptions;

  ActionModel(this.action, this.icon, this.description,
      {this.selected = false, this.hasOptions = false});

  @override
  List<Object> get props => [action, description];
}

// class ActionModelDetails {
//   final DragoIcons icon;
//   final String description;
//   final bool selected;
//   final Option<List> options;
//   final dynamic actionBase;

//   ActionModelDetails(this.icon, this.description,
//       {@required this.actionBase,
//       this.selected = false,
//       this.options = const None()});
// }

// abstract class Actionable {
//   ActionModelDetails toAction({bool selected = false});
// }

class SubmissionSort extends Equatable {
  final DragoIcons icon;
  final String _baseDescription;
  final SubmissionSortType type;
  final Option<SubmissionFilter> selectedFilter;
  final Option<List<SubmissionFilter>> filtersOptions;

  String get description {
    final desc = selectedFilter.fold(() => _baseDescription,
        (filter) => '$_baseDescription (${filter.description})');

    return desc;
  }

  const SubmissionSort(
    this.icon,
    this._baseDescription,
    this.type, {
    this.filtersOptions = const None(),
    this.selectedFilter = const None(),
  });

  @override
  List<Object> get props =>
      [icon, description, type, filtersOptions, selectedFilter];

  SubmissionSort copyWith({Option<SubmissionFilter> selectedFilter}) {
    return SubmissionSort(
      icon,
      _baseDescription,
      type,
      filtersOptions: filtersOptions,
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
  List<Object> get props => [icon, description, type, selected];

  SubmissionFilter copyWith({selected}) {
    return SubmissionFilter(icon, description, type,
        selected: selected ?? this.selected);
  }
}

final _hotSubmissionSort =
    SubmissionSort(DragoIcons.sort_hot, "Hot", SubmissionSortType.hot);
final _newestSubmissionSort =
    SubmissionSort(DragoIcons.sort_newest, "Newest", SubmissionSortType.newest);
final _risingSubmissionSort =
    SubmissionSort(DragoIcons.sort_rising, "Rising", SubmissionSortType.rising);
final _topSubmissionSort = SubmissionSort(
    DragoIcons.sort_top, "Top", SubmissionSortType.top,
    filtersOptions: Some(filters.values.toList()));
final _controversialSubmissionSort = SubmissionSort(
    DragoIcons.sort_controversial,
    "Controversial",
    SubmissionSortType.controversial,
    filtersOptions: Some(filters.values.toList()));

const filters = {
  TimeFilter_.hour: hourFilter,
  TimeFilter_.day: dayFilter,
  TimeFilter_.week: weekFilter,
  TimeFilter_.month: monthFilter,
  TimeFilter_.year: yearFilter,
  TimeFilter_.all: allFilter
};

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
