import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laporhoax/common/exception.dart';
import 'package:laporhoax/data/models/category.dart';
import 'package:laporhoax/data/models/challenge.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_response.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/report_response.dart';
import 'package:laporhoax/data/models/user_login.dart';
import 'package:laporhoax/data/models/user_question.dart';
import 'package:laporhoax/data/models/user_register.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/User.dart';

abstract class RemoteDataSource {
  Future<UserToken> postLogin(String username, String password);

  Future<UserRegister> postRegister(UserLogin user);

  Future<List<Category>> getCategory();

  Future<List<User>> getUserData(String email);

  Future<List<ReportModel>> getReport(String token, String id);

  Future<ReportModel> postReport(String token, ReportRequest report);

  Future<String> deleteReport(String token, ReportModel report);

  Future<List<FeedModel>> getFeeds();

  Future<Question> getQuestions();

  Future<Challenge> getUserQuestions(String id);

  Future postSecurityQNA(Challenge result);

  Future postFcmToken(String user, String fcmToken);

  Future<String> postChangePassword(
      String oldPass, String newPass, String token);

  Future<String> getPasswordReset(String email, String token);
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
  static final String isActiveEndpoint = 'isactive';
  static final String verifyOtpEndpoint = 'verifyotp';

  final Dio dio;

  RemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = baseUrl;
    dio.options.validateStatus = (int? status) {
      return status != null && status > 0;
    };
    dio.options.headers = <String, String>{
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
    };
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
      print(response.data);
      return UserToken.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserRegister> postRegister(UserLogin user) async {
    final response = await dio.post(
      '/$registerEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      print(response.data);
      return UserRegister.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    final response = await dio.get('/$reportCatEndpoint');

    if (response.statusCode == 200) {
      return categoryFromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<User>> getUserData(String email) async {
    final response = await dio.get(
      '/$getUserEndpint',
      options: Options(headers: <String, String>{
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      // return on list, but still only 1 entry
      return List<User>.from(response.data.map((x) => User.fromJson(x)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ReportModel>> getReport(String token, String id) async {
    final response = await dio.get(
      '/$reportsEndpoint/user/$id/',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      }),
    );

    if (response.statusCode == 200) {
      print('${response.data}');
      return UserReport.fromJson(response.data).reportList;
    } else {
      print('${response.statusCode}');
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

    if (response.statusCode == 201) {
      return ReportModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> deleteReport(String token, ReportModel report) async {
    final response = await dio.delete(
      '/$reportsEndpoint/${report.id}/',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      ),
    );

    if (response.statusCode == 201) {
      return 'success';
    } else {
      print('${response.statusCode}');
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
  Future<Question> getQuestions() async {
    final response = await dio.get('/$questionEndpoint');

    if (response.statusCode == 200) {
      return Question.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Challenge> getUserQuestions(String id) async {
    final response = await dio.get('/$questionEndpoint/user/$id');

    if (response.statusCode == 200) {
      return Challenge.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future postSecurityQNA(Challenge result) async {
    final response = await dio.post(
      '/$questionEndpoint/user/',
      options: Options(contentType: Headers.jsonContentType),
      data: result.toJson(),
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
  Future<String> postChangePassword(
      String oldPass, String newPass, String token) async {
    final response = await dio.post('/$passwordChangeEndpoint/',
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        ),
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
  Future<String> getPasswordReset(String email, String token) async {
    final response = await dio.get(
      '/$passwordResetEndpoint/$email',
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      ),
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }
}
