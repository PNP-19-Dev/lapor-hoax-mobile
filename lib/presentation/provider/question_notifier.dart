import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';

class QuestionNotifier extends ChangeNotifier {
  final GetQuestions getQuestions;
  final GetUserChallenge getUserChallenge;

  QuestionNotifier(
      {required this.getQuestions, required this.getUserChallenge});

  Map<int, String> _questionMap = {};

  Map<int, String> get questionMap => _questionMap;

  List<Question> _questions = [];

  List<Question> get question => _questions;

  RequestState _questionState = RequestState.Empty;

  RequestState get questionState => _questionState;

  String _questionMessage = '';

  String get questionMessage => _questionMessage;

  Future<void> fetchQuestions() async {
    _questionState = RequestState.Loading;
    notifyListeners();

    final result = await getQuestions.execute();

    result.fold((failure) {
      _questionMessage = failure.message;
      _questionState = RequestState.Error;
    }, (questions) {
      _questions = questions;
      _questionMap = _questionToMap();
      _questionState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Map<int, String> _questionToMap() {
    Map<int, String> map = {};
    _questions.forEach((element) {
      map[element.id] = '${element.question}';
    });
    return map;
  }

  late UserQuestion _userQuestion;

  UserQuestion get userQuestion => _userQuestion;

  String _userQuestionMessage = '';

  String get userQuestionMessage => _userQuestionMessage;

  RequestState _userQuestionState = RequestState.Empty;

  RequestState get userQuestionState => _userQuestionState;

  Future<void> getUserSecurityQuestion(int id) async {
    _userQuestionState = RequestState.Loading;
    notifyListeners();

    final result = await getUserChallenge.execute(id);

    result.fold((failure) {
      _userQuestionMessage = failure.message;
      _userQuestionState = RequestState.Error;
    }, (userQuestion) {
      _userQuestion = userQuestion;
      _userQuestionState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
