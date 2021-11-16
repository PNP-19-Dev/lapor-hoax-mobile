/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 21.07
 */

import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class SetSession {
  final Repository repository;

  SetSession(this.repository);

  Future<bool> execute({SessionData? data}) {
    return repository.setSession(data: data);
  }
}