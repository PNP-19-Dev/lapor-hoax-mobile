import 'dart:convert';

List<Feed> feedFromJson(String str) =>
    List<Feed>.from(json.decode(str).map((x) => Feed.fromJson(x)));

class Feed {
  Feed({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.imgpath,
    required this.date,
    required this.view,
    required this.author,
  });

  int id;
  String title;
  String content;
  String thumbnail;
  String imgpath;
  String date;
  int view;
  int author;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        thumbnail: json["thumbnail"],
        imgpath: json["imgpath"],
        date: json["date"],
        view: json["view"],
        author: json["author"],
      );
}
