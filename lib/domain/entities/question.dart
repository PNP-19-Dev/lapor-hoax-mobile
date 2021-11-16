/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.43
 */

import 'package:equatable/equatable.dart';

class Question extends Equatable {
  Question({
    required this.id,
    required this.question,
  });

  final int id;
  final String question;

  @override
  List<Object?> get props => [id, question];
}
