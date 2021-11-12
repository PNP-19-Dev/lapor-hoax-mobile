import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'password_cubit_test.mocks.dart';

@GenerateMocks([
  PostChangePassword,
  GetPasswordReset,
  GetUser,
])
void main() {
  late PasswordCubit bloc;
  late MockPostChangePassword _change;
  late MockGetPasswordReset _reset;
  late MockGetUser _user;

  setUp(() {
    _change = MockPostChangePassword();
    _reset = MockGetPasswordReset();
    _user = MockGetUser();
    bloc = PasswordCubit(_change, _reset, _user);
  });

  group('Get User', () {
    const tEmail = 'email';
    blocTest<PasswordCubit, PasswordState>(
      'Should get user data when usecase is called',
      build: () {
        when(_user.execute(tEmail)).thenAnswer((_) async => Right(testUser));
        return bloc;
      },
      act: (cubit) => cubit.getUserData(tEmail),
      verify: (cubit) => cubit.getUserData(tEmail),
      expect: () => [
        PasswordLoading(),
        UserHasData(testUser),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'Should return error callback when data is unsuccessful',
      build: () {
        when(_user.execute(tEmail))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.getUserData(tEmail),
      verify: (cubit) => cubit.getUserData(tEmail),
      expect: () => [
        PasswordLoading(),
        PasswordError('Failure'),
      ],
    );
  });

  group('Change Password', () {
    const oldPass = 'oldPass';
    const newPass = 'newPass';
    const token = 'token';

    blocTest<PasswordCubit, PasswordState>(
      'Should get success callback from the usecase when data has sent',
      build: () {
        when(_change.execute(oldPass, newPass, token))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (cubit) => cubit.changePassword(oldPass, newPass, token),
      verify: (cubit) => cubit.changePassword(oldPass, newPass, token),
      expect: () => [
        PasswordLoading(),
        PasswordReseted(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'Should get success callback from the usecase when data has sent',
      build: () {
        when(_change.execute(oldPass, newPass, token))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.changePassword(oldPass, newPass, token),
      verify: (cubit) => cubit.changePassword(oldPass, newPass, token),
      expect: () => [
        PasswordLoading(),
        PasswordError('Failure'),
      ],
    );
  });

  group('Reset Password', () {
    const email = 'oldPass';

    blocTest<PasswordCubit, PasswordState>(
      'Should get success callback from the usecase when data has sent',
      build: () {
        when(_reset.execute(email)).thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (cubit) => cubit.resetPassword(email),
      verify: (cubit) => cubit.resetPassword(email),
      expect: () => [
        PasswordLoading(),
        PasswordReseted(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'Should get success callback from the usecase when data has sent',
      build: () {
        when(_reset.execute(email))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.resetPassword(email),
      verify: (cubit) => cubit.resetPassword(email),
      expect: () => [
        PasswordLoading(),
        PasswordError('Failure'),
      ],
    );
  });
}
