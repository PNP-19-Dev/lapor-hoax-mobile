/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

part of 'question_cubit.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionError extends QuestionState {
  final String message;

  QuestionError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuestionHasData extends QuestionState {
  final List<Question> questions;
  Map<int, String>? questionMap;
  List<int>? index;
  List<String>? userQuestion;

  QuestionHasData(this.questions,
      this.questionMap,
      this.index,
      this.userQuestion,);

  factory QuestionHasData.question(List<Question> questions) =>
      QuestionHasData(questions, null, null, null);

  @override
  List<Object?> get props => [questions, index, userQuestion];
}

class ChallengeSending extends QuestionState {}

class ChallengeError extends QuestionState {
  final String message;

  ChallengeError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChallengeSuccess extends QuestionState {}
