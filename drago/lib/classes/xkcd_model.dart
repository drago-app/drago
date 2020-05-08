class XkcdModel {
  String month;
  int number;
  String link;
  String year;
  String news;
  String safeTitle;
  String transcript;
  String alt;
  String img;
  String title;
  String day;

  XkcdModel.fromJson(Map<String, dynamic> json) {
    month = json['month'] as String;
    number = json['number'] as int;
    link = json['link'] as String;
    year = json['year'] as String;
    news = json['news'] as String;
    safeTitle = json['safe_title'] as String;
    transcript = json['transcript'] as String;
    alt = json['alt'] as String;
    img = json['img'] as String;
    title = json['title'] as String;
    day = json['day'] as String;
  }
}
