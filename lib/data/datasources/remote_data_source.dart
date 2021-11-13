/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 01.34
 */

import 'dart:convert';
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
const String firebaseTokenEndpoint = 'auth/api/fcmToken';
const String passwordChangeEndpoint = 'auth/api/change-password';
const String passwordResetEndpoint = 'auth/api/reset';
const String reportsEndpoint = 'api/reports';
const String reportCatEndpoint = 'api/reports/cat';
const String feedsEndpoint = 'api/feeds';

abstract class RemoteDataSource {
  Future<String> deleteReport(String token, int id);
  Future<List<CategoryModel>> getCategory();
  Future<FeedModel> getFeedDetail(int id);
  Future<List<FeedModel>> getFeeds();
  Future<String> getPasswordReset(String email);
  Future<List<QuestionModel>> getQuestions();
  Future<List<ReportModel>> getReport(String token, int id);
  Future<UserModel> getUser(String email);
  Future<UserQuestionModel> getUserQuestions(int id);
  Future<String> postChangePassword(
      String oldPass, String newPass, String token);
  Future postFcmToken(String user, String fcmToken);
  Future updateFcmToken(String user, String fcmToken);
  Future<UserTokenModel> postLogin(String username, String password);
  Future<RegisterResponse> postRegister(RegisterModel user);
  Future<ReportModel> postReport(String token, ReportRequest report);
  Future<String> postChallenge(UserQuestionModel challenge);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final DioClient client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<UserTokenModel> postLogin(String username, String password) async {
    try {
      final response = await client.post(
        '/$loginEndpoint/',
        options: Options(contentType: Headers.jsonContentType),
        data: jsonEncode({
          "username": username,
          "password": password,
        }),
      );
      return UserTokenModel.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<RegisterResponse> postRegister(RegisterModel user) async {
    try {
      final response = await client.post(
        '/$registerEndpoint/',
        options: Options(contentType: Headers.jsonContentType),
        data: user.toJson(),
      );

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
      return List<UserModel>
          .from((response).map((x) => UserModel.fromJson(x)))
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
      var formData = FormData.fromMap({
        'user': report.user.toString(),
        'url': '"${report.url}"',
        'category': report.category,
        'isAnonym': report.isAnonym.toString(),
        'description': report.description,
        'img': await MultipartFile.fromFile(report.img.path,
            filename: report.img.name),
      });

      final response = await client.post('/$reportsEndpoint/',
          data: formData,
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Token $token',
            },
          ));

      return ReportModel.fromJson(response);
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> deleteReport(String token, int id) async {
    try {
      final response = await client.delete(
        '/$reportsEndpoint/$id/',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          },
        ),
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
      final response = await client.post(
        '/$questionEndpoint/user/',
        options: Options(contentType: Headers.jsonContentType),
        data: challenge.toJson(),
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future postFcmToken(String user, String fcmToken) async {
    try {
      final response = await client.post(
        '/$firebaseTokenEndpoint',
        options: Options(contentType: Headers.jsonContentType),
        data: <String, String>{
          'user': user,
          'token': fcmToken,
        },
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future updateFcmToken(String user, String fcmToken) async {
    try {
      final response = await client.put(
        '/$firebaseTokenEndpoint',
        options: Options(contentType: Headers.jsonContentType),
        data: <String, String>{
          'user': user,
          'token': fcmToken,
        },
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> postChangePassword(
      String oldPass, String newPass, String token) async {
    try {
      final response = await client.put('/$passwordChangeEndpoint/',
          options: Options(contentType: Headers.jsonContentType, headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }),
          data: <String, String>{
            "old_password": oldPass,
            "new_password": newPass,
          });
      return response;
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<String> getPasswordReset(String email) async {
    try {
      final response = await client.get('/$passwordResetEndpoint/$email');

      return response;
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
