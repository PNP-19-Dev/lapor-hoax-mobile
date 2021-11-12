/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/register_model.dart';

void main() {
  final tRegisterModel = RegisterModel(
    name: "name",
    email: "email",
    password: "password",
  );

  final registerMap = {
    "username": "name",
    "email": "email",
    "password": 'password',
  };

  group('Feed Model', () {
    test('should be a valid json', () async {
      final result = tRegisterModel.toJson();
      expect(result, registerMap);
    });
  });
}
