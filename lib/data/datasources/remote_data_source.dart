import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_response.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/question_response.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/report_response.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';

abstract class RemoteDataSource {
  Future<String> deleteReport(String token, int id);
  Future<List<CategoryModel>> getCategory();
  Future<FeedModel> getFeedDetail(int id);
  Future<List<FeedModel>> getFeeds();
  Future<String> getPasswordReset(String email);
  Future<List<QuestionModel>> getQuestions();
  Future<List<ReportModel>> getReport(String token, int id);
  Future<List<UserModel>> getUser(String email);
  Future<UserQuestionModel> getUserQuestions(int id);
  Future<String> postChangePassword(
      String oldPass, String newPass, String token);
  Future postFcmToken(String user, String fcmToken);
  Future updateFcmToken(String user, String fcmToken);
  Future<UserToken> postLogin(String username, String password);
  Future<UserResponse> postRegister(RegisterModel user);
  Future<ReportModel> postReport(String token, ReportRequest report);
  Future<String> postChallenge(UserQuestionModel challenge);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  static final String baseUrl = 'https://laporhoaxpolda.herokuapp.com';
  static final String loginEndpoint = 'auth/api/login';
  static final String registerEndpoint = 'auth/api/register';
  static final String getUserEndpint = 'auth/api/users/get';
  static final String questionEndpoint = 'auth/api/question';
  static final String firebaseTokenEndpoint = 'auth/api/fcmToken';
  static final String passwordChangeEndpoint = 'auth/api/change-password';
  static final String passwordResetEndpoint = 'auth/api/reset';

  static final String reportsEndpoint = 'api/reports';
  static final String reportCatEndpoint = 'api/reports/cat';
  static final String feedsEndpoint = 'api/feeds';

  final Dio dio;

  RemoteDataSourceImpl({required this.dio}) {
    // dio.options.baseUrl = baseUrl;
    // dio.options.validateStatus = (int? status) {
    //   return status != null && status > 0;
    // };
    // dio.options.headers = <String, String>{
    //   HttpHeaders.acceptHeader: '*/*',
    //   HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
    // };
  }

  @override
  Future<UserToken> postLogin(String username, String password) async {
    final response = await dio.post(
      '/$loginEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: jsonEncode(
        <String, String>{
          "username": username,
          "password": password,
        },
      ),
    );

    if (response.statusCode == 200) {
      return UserToken.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserResponse> postRegister(RegisterModel user) async {
    final response = await dio.post(
      '/$registerEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryModel>> getCategory() async {
    final response = await dio.get('/$reportCatEndpoint');

    if (response.statusCode == 200) {
      return List<CategoryModel>.from(
          (response.data).map((x) => CategoryModel.fromJson(x)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getUser(String email) async {
    final response = await dio.get(
      '/$getUserEndpint',
      options: Options(headers: <String, String>{
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      // return on list, but still only 1 entry
      return List<UserModel>.from(
          (response.data).map((x) => UserModel.fromJson(x)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ReportModel>> getReport(String token, int id) async {
    final response = await dio.get(
      '/$reportsEndpoint/user/$id/',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      }),
    );
    if (response.statusCode == 200) {
      return ReportResponse.fromJson(response.data).reportList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ReportModel> postReport(String token, ReportRequest report) async {
    var formData = FormData.fromMap({
      'user': report.user.toString(),
      'url': '"${report.url}"',
      'category': report.category,
      'isAnonym': report.isAnonym.toString(),
      'description': report.description,
      'img': await MultipartFile.fromFile(report.img.path,
          filename: report.img.name),
    });

    final response = await dio.post('/$reportsEndpoint/',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Token $token',
          },
        ));

    print('status code ${response.statusCode}');

    if (response.statusCode == 201) {
      return ReportModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> deleteReport(String token, int id) async {
    final response = await dio.delete(
      '/$reportsEndpoint/$id/',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      ),
    );
    print(
        'delete status code ${response.statusCode} ${response.statusMessage}');
    if (response.statusCode == 204) {
      return 'success';
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FeedModel>> getFeeds() async {
    final response = await dio.get('/$feedsEndpoint/');

    if (response.statusCode == 200) {
      return FeedResponse.fromJson(response.data).feedList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions() async {
    final response = await dio.get('/$questionEndpoint');

    if (response.statusCode == 200) {
      return QuestionResponse.fromJson(response.data).questionList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserQuestionModel> getUserQuestions(int id) async {
    final response = await dio.get('/$questionEndpoint/user/$id');

    if (response.statusCode == 200) {
      return UserQuestionModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> postChallenge(UserQuestionModel challenge) async {
    final response = await dio.post(
      '/$questionEndpoint/user/',
      options: Options(contentType: Headers.jsonContentType),
      data: challenge.toJson(),
    );

    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw ServerException();
    }
  }

  @override
  Future postFcmToken(String user, String fcmToken) async {
    final response = await dio.post(
      '/$firebaseTokenEndpoint',
      options: Options(contentType: Headers.jsonContentType),
      data: <String, String>{
        'user': user,
        'token': fcmToken,
      },
    );

    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw ServerException();
    }
  }

  @override
  Future updateFcmToken(String user, String fcmToken) async {
    final response = await dio.put(
      '/$firebaseTokenEndpoint',
      options: Options(contentType: Headers.jsonContentType),
      data: <String, String>{
        'user': user,
        'token': fcmToken,
      },
    );

    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> postChangePassword(
      String oldPass, String newPass, String token) async {
    final response = await dio.put('/$passwordChangeEndpoint/',
        options: Options(contentType: Headers.jsonContentType, headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }),
        data: <String, String>{
          "old_password": oldPass,
          "new_password": newPass,
        });

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getPasswordReset(String email) async {
    final response = await dio.get(
      '/$passwordResetEndpoint/$email',
      options: Options(contentType: Headers.jsonContentType),
    );
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  @override
  Future<FeedModel> getFeedDetail(int id) async {
    final response = await dio.get('/$feedsEndpoint/$id');

    if (response.statusCode == 200) {
      return FeedModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
