

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class Subreddit {
  /// This is the common name of the subreddit
  /// e.g. 'gadgets'
  final String? displayName;

  /// This is a high level description of the subreddit
  /// e.g. "r/Apple - the unofficial Apple community",
  final String? title;

  /// This is the 'thing' name  of the subreddit
  /// e.g. 't5_2qgzt
  final String? name;
  final Option<Uri> iconImage;
  final bool? quarantined;
  final bool? over18;

  /// Does every subreddit have this??
  final String? publicDescription;

  // Does every subreddit have this??
  final String? submitText;

  /// This is the allowable submission types
  /// Some subreddits can be 'link' others can be any.
  /// I dont have an exhaustive list of types so I'm not implementing at the moment
  /// todo (donovan)
  // final List submissionType;

  Subreddit({
    required this.displayName,
    required this.title,
    required this.name,
    required this.quarantined,
    required this.over18,
    required this.publicDescription,
    required this.submitText,
    required this.iconImage,
  });

  factory Subreddit.fromJson(Map<String?, dynamic> json) {
    return Subreddit(
      displayName: json['display_name'],
      title: json['title'],
      name: json['name'],
      quarantined: json['quarantine'],
      over18: json['over_18'],
      publicDescription: json['public_description'],
      submitText: json['submit_text'],
      iconImage: optionOf(Uri.parse(json['icon_img'])),
    );
  }
}
