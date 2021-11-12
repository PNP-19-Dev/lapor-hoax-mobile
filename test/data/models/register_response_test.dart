/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/register_response.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/entities/user.dart';

void main() {
  final tUserModel = UserModel(
    id: 1,
    username: 'username',
    email: 'email',
  );

  final tRegisterResponse = RegisterResponse(
    user: tUserModel,
    token: 'token',
  );

  final tUser = User(
    id: 1,
    username: 'username',
    email: 'email',
  );

  final tRegisterData = RegisterData(
    user: tUser,
    token: 'token',
  );

  final registerMap = {
    'user': {
      'id': 1,
      'username': 'username',
      'email': 'email',
    },
    'token': 'token'
  };

  group('Register Response', () {
    test('should return a valid model from JSON', () {
      final result = RegisterResponse.fromJson(registerMap);
      // assert
      expect(result, tRegisterResponse);
    });

    test('should be a subclass of register data', () {
      final result = tRegisterResponse.toEntity();
      // assert
      expect(result, tRegisterData);
    });
  });
}
