/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:laporhoax/domain/repositories/repository.dart';

class GetFeedSaveStatus {
  final Repository repository;

  GetFeedSaveStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToSavedFeed(id);
  }
}
