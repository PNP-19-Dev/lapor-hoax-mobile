import 'package:equatable/equatable.dart';

import '../../domain/entities/feed.dart';

class FeedModel extends Equatable {
  FeedModel({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.date,
    required this.view,
    required this.author,
  });

  final int id;
  final String title;
  final String? content;
  final String? thumbnail;
  final String date;
  final int? view;
  final int? author;

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
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
        "content": content,
        "thumbnail": thumbnail,
        "date": date,
        "view": view,
        "author": author
      };

  Feed entity() => Feed(
        id: id,
        title: title,
        content: content,
        thumbnail: thumbnail,
        date: date,
        view: view,
        author: author,
      );

  Feed toEntity() => Feed(
        id: this.id,
        title: this.title,
        content: this.content,
        thumbnail: this.thumbnail,
        date: this.date,
        view: this.view,
        author: this.author,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        thumbnail,
        date,
        view,
        author,
      ];
}
