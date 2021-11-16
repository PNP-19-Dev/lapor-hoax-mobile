/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.48
 */

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Report extends Equatable {
  Report({
    required this.id,
    required this.url,
    required this.img,
    required this.category,
    required this.status,
    required this.isAnonym,
    required this.dateReported,
    required this.description,
    required this.prosesDate,
    required this.verdict,
    required this.verdictDesc,
    required this.verdictDate,
    required this.user,
    required this.verdictJudge,
  });

  int id;
  String? url;
  String? img;
  String? category;
  String? status;
  bool? isAnonym;
  String? dateReported;
  String? description;
  String? prosesDate;
  String? verdict;
  String? verdictDesc;
  String? verdictDate;
  int? user;
  int? verdictJudge;

  @override
  List<Object?> get props => [
    id,
    url,
    img,
    category,
    status,
    isAnonym,
    dateReported,
    description,
    prosesDate,
    verdict,
    verdictDesc,
    verdictDate,
    user,
    verdictJudge
  ];
}
