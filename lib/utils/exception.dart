/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 01.25
 */

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}