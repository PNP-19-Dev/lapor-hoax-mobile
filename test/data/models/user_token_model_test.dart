/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/user_token_model.dart';
import 'package:laporhoax/domain/entities/user_token.dart';

void main() {
  final tTokenModel = UserTokenModel(
    token: 'token',
    expiry: 'expiry',
  );

  final tToken = UserToken(
    token: 'token',
    expiry: 'expiry',
  );

  final tokenMap = {
    'token' : 'token',
    'expiry' : 'expiry',
  };

  group('User Question Model', () {
    test('should be a subclass of Entity From JSON', () async {
      final result = UserTokenModel.fromJson(tokenMap);
      expect(result, tTokenModel);
    });

    test('should be a valid entity', () async {
      final result = tTokenModel.toEntity();
      expect(result, tToken);
    });
  });
}
