import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SubredditTile {
  const SubredditTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    @required this.iconColor,
    @required this.subreddit
  })  : assert(title != null),
        assert(subtitle != null),
        assert(icon != null),
        assert(iconColor != null),
        assert(subreddit != null);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String subreddit;

  @override
  String toString() => '$title (id=$subtitle)';
}