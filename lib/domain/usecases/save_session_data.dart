/*
 * Created by andii on 15/11/21 13.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.55
 */

import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class SaveSessionData {
  final Repository repository;

  SaveSessionData(this.repository);

  Future<String> execute(SessionData data) {
    return repository.saveSessionData(data);
  }
}
