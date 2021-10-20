import 'package:flutter/material.dart';
import 'package:laporhoax/common/result_state.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/user_question.dart';
import 'package:laporhoax/data/model/user_response.dart';
import 'package:laporhoax/data/models/category.dart';

class ListProviders extends ChangeNotifier {
  static ListProviders? _instance;
  late final LaporhoaxApi _api;
  List<QuestionResult> _questionList = [];
  List<Category> _categoryList = [];
  List<String> _userAns = [];
  List<int> _index = [];
  late ResultState _state;
  String _message = '';

  ListProviders.internal() {
    _instance = this;
    _api = LaporhoaxApi();
    _getCategory();
    _getQuestion();
  }

  factory ListProviders() => _instance ?? ListProviders.internal();

  List<int> get index => _index;

  List<String> get userAns => _userAns;

  List<QuestionResult> get questionList => _questionList;

  List<Category> get categoryList => _categoryList;

  ResultState get state => _state;

  String get message => _message;

  Future<dynamic> _getQuestion() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      _questionList.clear();
      var questions = await _api.getQuestions();
      _state = ResultState.HasData;
      notifyListeners();
      _questionList = questions.results;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      print('error: $e');
      return _message = 'error $e';
    }
  }

  Map<int, String> questionToMap() {
    Map<int, String> map = {};
    _questionList.forEach((element) {
      map[element.id] = '${element.question}';
    });
    return map;
  }

  Future<User> getUserData(String email) async {
    var response = await _api.getUserData(email);
    return response.first;
  }

  Future<dynamic> getUserQuestion(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      _userAns.clear();
      _index.clear();
      var response = await _api.getUserQuestions(id);
      _state = ResultState.HasData;
      notifyListeners();
      return response;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      print('error: $e');
      return _message = 'err=r $e';
    }
  }

  Future<dynamic> _getCategory() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      _categoryList.clear();
      var category = await _api.getCategory();
      _state = ResultState.HasData;
      notifyListeners();
      return _categoryList = category;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      print('error: $e');
      return _message = 'err=r $e';
    }
  }
}
