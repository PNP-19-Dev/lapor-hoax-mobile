import 'package:equatable/equatable.dart';

import '../../domain/entities/feed.dart';

class FeedTable extends Equatable {
  final int id;
  final String? title;
  final String? thumbnail;
  final String? date;

  FeedTable({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.date,
  });

  factory FeedTable.fromEntity(Feed feed) => FeedTable(
        id: feed.id,
        title: feed.title,
        thumbnail: feed.thumbnail,
        date: feed.date,
      );

  factory FeedTable.fromMap(Map<String, dynamic> map) => FeedTable(
        id: map['id'],
        title: map['title'],
        thumbnail: map['thumbnail'],
        date: map['date'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'date': date,
      };

  Feed toEntity() =>
      Feed.toDb(id: id, title: title, thumbnail: thumbnail, date: date);

  @override
  List<Object?> get props => [id, title, thumbnail, date];
}
