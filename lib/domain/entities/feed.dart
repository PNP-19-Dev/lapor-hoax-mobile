/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.48
 */

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Feed extends Equatable {
  Feed(
      {required this.id,
      required this.title,
      required this.content,
      required this.thumbnail,
      required this.date,
    required this.view,
    required this.author});

  Feed.toDb({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.date,
  });

  final int id;
  String? title;
  String? content;
  String? thumbnail;
  String? date;
  int? view;
  int? author;

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
