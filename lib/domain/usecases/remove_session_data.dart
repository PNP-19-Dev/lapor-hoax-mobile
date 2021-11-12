/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class RemoveSessionData {
  final Repository repository;

  RemoveSessionData(this.repository);

  Future<String> execute(SessionData data) {
    return repository.removeSessionData(data);
  }
}
