/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:laporhoax/domain/repositories/repository.dart';

class GetSessionStatus {
  final Repository repository;

  GetSessionStatus(this.repository);

  Future<bool> execute() {
    return repository.isSessionActivated();
  }
}
