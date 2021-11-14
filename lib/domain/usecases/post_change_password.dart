/*
 * Created by andii on 14/11/21 10.32
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 09.49
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostChangePassword {
  final Repository repository;

  PostChangePassword(this.repository);

  Future<Either<Failure, String>> execute(String oldPass, String newPass, String token) {
    return repository.putPassword(oldPass, newPass, token);
  }
}
