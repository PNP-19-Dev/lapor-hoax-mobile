import 'package:flutter/cupertino.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/user_question.dart';
import '../../domain/usecases/get_questions.dart';
import '../../domain/usecases/get_user_challenge.dart';
import '../../utils/state_enum.dart';

class QuestionNotifier extends ChangeNotifier {
  final GetQuestions getQuestions;
  final GetUserChallenge getUserChallenge;

  QuestionNotifier(
      {required this.getQuestions, required this.getUserChallenge});

  Map<int, String> _questionMap = {};

  Map<int, String> get questionMap => _questionMap;

  List<Question> _questions = [];

  List<Question> get question => _questions;

  RequestState _questionState = RequestState.empty;

  RequestState get questionState => _questionState;

  String _questionMessage = '';

  String get questionMessage => _questionMessage;

  Future<void> fetchQuestions() async {
    _questionState = RequestState.loading;
    notifyListeners();

    final result = await getQuestions.execute();

    result.fold((failure) {
      _questionState = RequestState.error;
      notifyListeners();
      _questionMessage = failure.message;
    }, (questions) {
      _questionState = RequestState.loaded;
      notifyListeners();
      _questions = questions;
      _questionMap = _questionToMap();
    });
  }

  Map<int, String> _questionToMap() {
    Map<int, String> map = {};
    for (var element in _questions) {
      map[element.id] = element.question;
    }
    return map;
  }

  late UserQuestion _userQuestion;

  UserQuestion get userQuestion => _userQuestion;

  String _userQuestionMessage = '';

  String get userQuestionMessage => _userQuestionMessage;

  RequestState _userQuestionState = RequestState.empty;

  RequestState get userQuestionState => _userQuestionState;

  Future<void> getUserSecurityQuestion(int id) async {
    _userQuestionState = RequestState.loading;
    notifyListeners();

    final result = await getUserChallenge.execute(id);

    result.fold((failure) {
      _userQuestionState = RequestState.error;
      _userQuestionMessage = failure.message;
      notifyListeners();
    }, (userQuestion) {
      _userQuestionState = RequestState.loaded;
      _userQuestion = userQuestion;
      notifyListeners();
    });
  }
}
