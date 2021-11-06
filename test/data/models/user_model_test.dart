import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/domain/entities/user.dart';

void main() {
  final tUserModel = UserModel(
    id: 1,
    username: "username",
    email: "email",
  );

  final tUser = User(
    id: 1,
    username: "username",
    email: "email",
  );

  final userMap = {
    'id' : 1,
    'username' : 'username',
    'email' : 'email',
  };

  group('User Model', (){
    test('should be a subclass of UserModel from entity', () async {
      final result = tUserModel.toEntity();
      expect(result, tUser);
    });

    test('should be a valid of UserModel from json', () async {
      final result = UserModel.fromJson(userMap);
      expect(result, tUserModel);
    });

    test('should be a valid User', () async {
      final result = tUserModel.toEntity();
      expect(result, tUser);
    });
  });
}
