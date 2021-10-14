class Feeds {
  Feeds({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String? next;
  String? previous;
  List<Feed> results;

  factory Feeds.fromJson(Map<String, dynamic> json) => Feeds(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Feed>.from(json["results"].map((x) => Feed.fromJson(x))),
      );
}

class Feed {
  Feed({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.date,
    required this.view,
    required this.author,
  });

  int id;
  String title;
  String? content;
  String thumbnail;
  String date;
  int? view;
  int? author;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        thumbnail: json["thumbnail"],
        date: json["date"],
        view: json["view"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "date": date,
      };
}
