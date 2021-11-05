// Mocks generated by Mockito 5.0.16 from annotations
// in laporhoax/test/presentation/provider/question_notifier_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:laporhoax/domain/entities/question.dart' as _i7;
import 'package:laporhoax/domain/entities/user_question.dart' as _i9;
import 'package:laporhoax/domain/repositories/repository.dart' as _i2;
import 'package:laporhoax/domain/usecases/get_questions.dart' as _i4;
import 'package:laporhoax/domain/usecases/get_user_challenge.dart' as _i8;
import 'package:laporhoax/utils/failure.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeRepository_0 extends _i1.Fake implements _i2.Repository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetQuestions].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetQuestions extends _i1.Mock implements _i4.GetQuestions {
  MockGetQuestions() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Repository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeRepository_0()) as _i2.Repository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.Question>>> execute() =>
      (super.noSuchMethod(Invocation.method(#execute, []),
              returnValue:
                  Future<_i3.Either<_i6.Failure, List<_i7.Question>>>.value(
                      _FakeEither_1<_i6.Failure, List<_i7.Question>>()))
          as _i5.Future<_i3.Either<_i6.Failure, List<_i7.Question>>>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [GetUserChallenge].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetUserChallenge extends _i1.Mock implements _i8.GetUserChallenge {
  MockGetUserChallenge() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Repository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeRepository_0()) as _i2.Repository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i9.UserQuestion>> execute(int? id) =>
      (super.noSuchMethod(Invocation.method(#execute, [id]),
          returnValue: Future<_i3.Either<_i6.Failure, _i9.UserQuestion>>.value(
              _FakeEither_1<_i6.Failure, _i9.UserQuestion>())) as _i5
          .Future<_i3.Either<_i6.Failure, _i9.UserQuestion>>);
  @override
  String toString() => super.toString();
}
