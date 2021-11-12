/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetFeedDetail {
  final Repository repository;

  GetFeedDetail(this.repository);

  Future<Either<Failure, Feed>> execute(int id) {
    return repository.getFeedDetail(id);
  }
}
