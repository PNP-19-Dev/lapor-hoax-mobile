import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/feed_model.dart';

class FeedResponse extends Equatable {
  FeedResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.feedList,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<FeedModel> feedList;

  factory FeedResponse.fromJson(Map<String, dynamic> json) => FeedResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        feedList: List<FeedModel>.from((json["results"] as List)
            .map((e) => FeedModel.fromJson(e))
            .where((element) => element.thumbnail != null)),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(feedList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [feedList];
}
