/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 18.26
 */


import 'package:laporhoax/domain/repositories/repository.dart';

class SetDarkMode{
  final Repository repository;

  SetDarkMode(this.repository);

  Future<bool> execute(bool value) {
    return repository.setDark(value);
  }
}