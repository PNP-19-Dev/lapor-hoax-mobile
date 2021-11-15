/*
 * Created by andii on 15/11/21 12.51
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.07
 */

import 'package:laporhoax/domain/repositories/repository.dart';

class SaveSessionData {
  final Repository repository;

  SaveSessionData(this.repository);

  Future<String> execute({
    required int id,
    required String expiry,
    required String token,
    required String email,
    required String username,
  }) {
    return repository.saveSessionData(
      id: id,
      expiry: expiry,
      token: token,
      email: email,
      username: username,
    );
  }
}
