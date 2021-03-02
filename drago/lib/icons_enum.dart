import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

enum DragoIcons {
  upvote,
  downvote,
  save,
  reply,
  share,
  post_tab,
  inbox_tab,
  accounts_tab,
  search_tab,
  settings_tab,
  options,
  sort_hot,
  sort_top,
  sort_controversial,
  sort_newest,
  sort_rising,
  submission_stickied,
  thumbnail_link,
  thumbnail_video,
  chevron_right,
  chat_bubble,
  clear,
  time_filter_hour,
  time_filter_day,
  time_filter_week,
  time_filter_month,
  time_filter_year,
  time_filter_all,
  selected,
}
final Map<DragoIcons, dynamic> iconMap = {
  DragoIcons.upvote: CupertinoIcons.arrow_up,
  DragoIcons.downvote: CupertinoIcons.arrow_down,
  DragoIcons.save: CupertinoIcons.bookmark,
  DragoIcons.reply: CupertinoIcons.reply,
  DragoIcons.share: CupertinoIcons.square_arrow_up,
  DragoIcons.post_tab: CupertinoIcons.today,
  DragoIcons.inbox_tab: CupertinoIcons.envelope_fill,
  DragoIcons.accounts_tab: CupertinoIcons.profile_circled,
  DragoIcons.search_tab: CupertinoIcons.search,
  DragoIcons.settings_tab: CupertinoIcons.settings_solid,
  DragoIcons.options: CupertinoIcons.ellipsis,
  DragoIcons.sort_hot: CupertinoIcons.flame,
  DragoIcons.sort_top: CupertinoIcons.sort_up,
  // DragoIcons.sort_controversial: ,
  DragoIcons.sort_newest: CupertinoIcons.clock,
  // DragoIcons.sort_rising:
  // DragoIcons.submission_stickied:
  // DragoIcons.thumbnail_link:
  // DragoIcons.thumbnail_video:
  DragoIcons.chevron_right: CupertinoIcons.chevron_right,
  DragoIcons.chat_bubble: CupertinoIcons.chat_bubble,
  DragoIcons.clear: CupertinoIcons.clear,
  DragoIcons.time_filter_hour: CupertinoIcons.calendar,
  DragoIcons.time_filter_day: CupertinoIcons.calendar,
  DragoIcons.time_filter_week: CupertinoIcons.calendar,
  DragoIcons.time_filter_month: CupertinoIcons.calendar,
  DragoIcons.time_filter_year: CupertinoIcons.calendar,
  DragoIcons.time_filter_all: CupertinoIcons.calendar,
  DragoIcons.selected: CupertinoIcons.checkmark_alt
};

final getIconData =
    (DragoIcons icon) => iconMap[icon] ?? CupertinoIcons.clear_thick_circled;