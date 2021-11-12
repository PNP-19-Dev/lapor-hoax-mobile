/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostFCMToken {
  final Repository repository;

  PostFCMToken(this.repository);

  Future<Either<Failure, String>> execute(int user, String fcmToken) {
    return repository.postFCMToken(user, fcmToken);
  }
}
