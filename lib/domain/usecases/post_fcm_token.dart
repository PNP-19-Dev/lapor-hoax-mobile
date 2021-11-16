/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 18.16
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostFCMToken {
  final Repository repository;

  PostFCMToken(this.repository);

  Future<Either<Failure, String>> execute(int user, String? fcmToken) {
    return repository.postFCMToken(user, fcmToken);
  }
}
