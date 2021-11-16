/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 22.23
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laporhoax/data/datasources/api/dio_client.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_response.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/question_response.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/register_response.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/report_response.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/models/user_token_model.dart';
import 'package:laporhoax/utils/network_exceptions.dart';

const String baseUrl = 'https://laporhoaxpolda.herokuapp.com';
const String loginEndpoint = 'auth/api/login';
const String registerEndpoint = 'auth/api/register';
const String getUserEndpoint = 'auth/api/users/get';
const String questionEndpoint = 'auth/api/question';
const String firebaseTokenEndpoint = 'auth/api/fcmtoken';
const String passwordChangeEndpoint = 'auth/api/change-password';
const String passwordResetEndpoint = 'auth/api/reset';
const String reportsEndpoint = 'api/reports';
const String reportCatEndpoint = 'api/reports/cat';
const String feedsEndpoint = 'api/feeds';

abstract class RemoteDataSource {
  Future<List<CategoryModel>> getCategory();
  Future<FeedModel> getFeedDetail(int id);
  Future<List<FeedModel>> getFeeds();
  Future<String> getPasswordReset(String email);
  Future<List<QuestionModel>> getQuestions();
  Future<List<ReportModel>> getReport(String token, int id);
  Future<UserModel> getUser(String email);
  Future<UserQuestionModel> getUserQuestions(int id);
  Future<UserTokenModel> postLogin(String username, String password);
  Future<RegisterResponse> postRegister(RegisterModel user);
  Future<String> postFcmToken(String user, String? fcmToken);
  Future<ReportModel> postReport(String token, ReportRequest report);
  Future<String> postChallenge(UserQuestionModel challenge);
  Future<String> putPassword(String oldPass, String newPass, String token);
  Future<String> putFcmToken(String user, String fcmToken);
  Future<String> deleteReport(String token, int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final DioClient client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<UserTokenModel> postLogin(String username, String password) async {
    try {
      final response = await client.post('/$loginEndpoint/',
          data: {"username": username, "password": password});

      return UserTokenModel.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<RegisterResponse> postRegister(RegisterModel user) async {
    try {
      final response =
          await client.post('/$registerEndpoint/', data: user.toJson());

      return RegisterResponse.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<List<CategoryModel>> getCategory() async {
    try {
      final response = await client.get('/$reportCatEndpoint');

      return List<CategoryModel>.from(
          (response).map((x) => CategoryModel.fromJson(x)));
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<UserModel> getUser(String email) async {
    try {
      final response = await client.get(
        '/$getUserEndpoint',
        headers: <String, dynamic>{"email": email},
      );
      return List<UserModel>.from((response).map((x) => UserModel.fromJson(x)))
          .toList()
          .first;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<List<ReportModel>> getReport(String token, int id) async {
    try {
      final response = await client.get(
        '/$reportsEndpoint/user/$id/',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      );
      return ReportResponse.fromJson(response).reportList;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<ReportModel> postReport(String token, ReportRequest report) async {
    try {
      final formData = FormData.fromMap({
        'user': report.user.toString(),
        'url': report.url,
        'category': report.category,
        'isAnonym': report.isAnonym.toString(),
        'description': report.description,
        'img': await MultipartFile.fromFile(report.img.path,
            filename: report.img.name),
      });

      final response = await client.post('/$reportsEndpoint/',
          data: formData,
          headers: {HttpHeaders.authorizationHeader: "Token $token"});

      return ReportModel.fromJson(response);
    } catch (e) {
      print(e);
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> deleteReport(String token, int id) async {
    try {
      final response = await client.delete(
        '/$reportsEndpoint/$id/',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      );

      return response;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<List<FeedModel>> getFeeds() async {
    try {
      final response = await client.get('/$feedsEndpoint/');
      return FeedResponse.fromJson(response).feedList;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions() async {
    try {
      final response = await client.get('/$questionEndpoint');
      return QuestionResponse.fromJson(response).questionList;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<UserQuestionModel> getUserQuestions(int id) async {
    try {
      final response = await client.get('/$questionEndpoint/user/$id');
      return UserQuestionModel.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> postChallenge(UserQuestionModel challenge) async {
    try {
      await client.post('/$questionEndpoint/user/',
          data: challenge.toJson());
      return 'Success';
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> postFcmToken(String user, String? fcmToken) async {
    try {
      await client.post('/$firebaseTokenEndpoint',
          data: {'user': user, 'token': fcmToken!});
      return 'Success';
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> putFcmToken(String user, String fcmToken) async {
    try {
      await client.put('/$firebaseTokenEndpoint', data: {
        'user': user,
        'token': fcmToken,
      });
      return 'Success';
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> putPassword(
      String oldPass, String newPass, String token) async {
    try {
      await client.put('/$passwordChangeEndpoint/',
          data: {"old_password": oldPass, "new_password": newPass},
          headers: {HttpHeaders.authorizationHeader: "Token $token"});
      return 'Success';
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> getPasswordReset(String email) async {
    try {
      await client.get('/$passwordResetEndpoint/$email');
      return 'Success';
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<FeedModel> getFeedDetail(int id) async {
    try {
      final response = await client.get('/$feedsEndpoint/$id');

      return FeedModel.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }
}
