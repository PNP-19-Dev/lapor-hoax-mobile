/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/data/models/register.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostRegister {
  final Repository repository;

  PostRegister(this.repository);

  Future<Either<Failure, RegisterData>> execute(Register user) {
    return repository.postRegister(user);
  }
}
