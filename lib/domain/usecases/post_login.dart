/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/user_token.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostLogin {
  final Repository repository;

  PostLogin(this.repository);

  Future<Either<Failure, UserToken>> execute(String username, String password) {
    return repository.postLogin(username, password);
  }
}
