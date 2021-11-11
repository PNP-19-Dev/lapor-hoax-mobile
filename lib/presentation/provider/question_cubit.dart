import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetUserChallenge _challenge;
  final GetQuestions _questions;
  final PostUserChallenge _send;

  QuestionCubit(
    this._challenge,
    this._questions,
    this._send,
  ) : super(QuestionInitial());

  Future<void> fetchQuestions() async {
    emit(QuestionLoading());
    final result = await _questions.execute();

    result.fold(
      (failure) => emit(QuestionError(failure.message)),
      (data) => emit(QuestionHasData.question(data)),
    );
  }

  Future<void> fetchQuestionWithChallenge(int id) async {
    emit(QuestionLoading());
    final result = await _questions.execute();
    result.fold(
      (failure) => emit(QuestionError(failure.message)),
      (question) async {
        final data = await _challenge.execute(id);
        data.fold(
          (failure) => emit(QuestionError(failure.message)),
          (data) => emit(QuestionHasData(question, _questionToMap(question),
              _getIndexQuestion(data), _getAnswerQuestion(data))),
        );
      },
    );
  }

  Map<int, String> _questionToMap(List<Question> questions) {
    Map<int, String> map = {};
    questions.forEach((element) {
      map[element.id] = '${element.question}';
    });
    return map;
  }

  List<int>? _getIndexQuestion(UserQuestion userQuestion) {
    List<int> index = [];
    index.addAll([
      userQuestion.quest1 ?? 0,
      userQuestion.quest2 ?? 0,
      userQuestion.quest3 ?? 0
    ]);

    return index;
  }

  List<String>? _getAnswerQuestion(UserQuestion userQuestion) {
    List<String> index = [];
    index.addAll([
      userQuestion.ans1 ?? '',
      userQuestion.ans2 ?? '',
      userQuestion.ans3 ?? ''
    ]);
    return index;
  }

  Future<void> sendQuestions(UserQuestion question) async {
    emit(ChallengeSending());

    final result = await _send.execute(question);
    result.fold(
      (failure) => emit(ChallengeError(failure.message)),
      (success) => emit(ChallengeSuccess()),
    );
  }
}
