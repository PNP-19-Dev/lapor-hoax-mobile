import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laporhoax/data/model/challenge.dart';
import 'package:laporhoax/data/model/feed_model.dart';
import 'package:laporhoax/data/model/report_request.dart';
import 'package:laporhoax/data/model/report_response.dart';
import 'package:laporhoax/data/model/user_login.dart';
import 'package:laporhoax/data/model/user_question.dart';
import 'package:laporhoax/data/model/user_register.dart';
import 'package:laporhoax/data/model/user_response.dart';
import 'package:laporhoax/data/model/user_token.dart';
import 'package:laporhoax/data/models/category.dart';
import 'package:laporhoax/data/models/challenge.dart';
import 'package:laporhoax/domain/entities/report.dart';

class LaporhoaxApi {
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
  static LaporhoaxApi? _instance;

  late final Dio _dio;

  LaporhoaxApi._internal() {
    _instance = this;
    _dio = Dio();

    _dio.options.baseUrl = baseUrl;
    _dio.options.validateStatus = (int? status) {
      return status != null && status > 0;
    };
    _dio.options.headers = <String, String>{
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
    };
  }

  factory LaporhoaxApi() => _instance ?? LaporhoaxApi._internal();

  // return token
  Future<UserToken> postLogin(String username, String password) async {
    final response = await _dio
        .post(
          '/$loginEndpoint/',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode(
            <String, String>{
              "username": username,
              "password": password,
            },
          ),
        )
        .onError((error, stackTrace) => throw Exception('No Internet'));

    if (response.statusCode == 200) {
      print(response.data);
      return UserToken.fromJson(response.data);
    } else {
      print('Response : ${response.statusCode}');
      throw Exception('\nStatus: ${response.data} (${response.statusCode})');
    }
  }

  Future<UserRegister> postRegister(UserLogin user) async {
    final response = await _dio.post(
      '/$registerEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: user.toJson(),
    );

    if (response.statusCode == 200) {
      return UserRegister.fromJson(response.data);
    } else if (response.statusCode == 400) {
      throw Exception('akun sudah ada!');
    } else {
      throw Exception('Gagal untuk mendaftar : ${response.statusCode}');
    }
  }

  Future<List<Category>> getCategory() async {
    final response = await _dio.get('/$reportCatEndpoint');

    if (response.statusCode == 200) {
      return categoryFromJson(response.data);
    } else {
      throw Exception('gagal mendapatkan kategori');
    }
  }

  Future<List<User>> getUserData(String email) async {
    final response = await _dio.get(
      '/$getUserEndpint',
      options: Options(headers: <String, String>{
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      // return on list, but still only 1 entry
      return List<User>.from(response.data.map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to retrieve user data ${response.statusCode}');
    }
  }

  Future<UserReport> getReport(String token, String id) async {
    final response = await _dio.get(
      '/$reportsEndpoint/user/$id/',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      }),
    );

    if (response.statusCode == 200) {
      print('${response.data}');
      return UserReport.fromJson(response.data);
    } else {
      print('${response.statusCode}');
      throw Exception('Failed to load report ${response.statusCode}');
    }
  }

  Future<ReportItem> postReport(String token, Report report) async {
    var formData = FormData.fromMap({
      'user': report.user.toString(),
      'url': '"${report.url}"',
      'category': report.category,
      'isAnonym': report.isAnonym.toString(),
      'description': report.description,
      'img': await MultipartFile.fromFile(report.img.path,
          filename: report.img.name),
    });

    final response = await _dio.post('/$reportsEndpoint/',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Token $token',
          },
        ));

    if (response.statusCode == 201) {
      return ReportItem.fromJson(response.data);
    } else {
      throw Exception('Failed to post report ${response.statusCode}');
    }
  }

  Future<String> deleteReport(String token, String reportId) async {
    final response = await _dio.delete(
      '/$reportsEndpoint/$reportId/',
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
      throw Exception('Failed to delete report ${response.statusCode}');
    }
  }

  Future<Feeds> getFeeds({String page = ""}) async {
    var response = await _dio.get('/$feedsEndpoint/');

    if (page.isNotEmpty) {
      response =
          await _dio.get('/$feedsEndpoint/', queryParameters: {'page': page});
    }

    if (response.statusCode == 200) {
      return Feeds.fromJson(response.data);
    } else {
      throw Exception('Failed to load feeds!');
    }
  }

  Future<FeedModel> getFeedById(String id) async {
    final response = await _dio.get('/$feedsEndpoint/$id');

    if (response.statusCode == 200) {
      return FeedModel.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to load feed by id');
    }
  }

  Future<Question> getQuestions() async {
    final response = await _dio.get('/$questionEndpoint');

    if (response.statusCode == 200) {
      return Question.fromJson(response.data);
    } else {
      throw Exception('failed to get user security question');
    }
  }

  Future<Challenge> getUserQuestions(String id) async {
    final response = await _dio.get('/$questionEndpoint/user/$id');

    if (response.statusCode == 200) {
      return Challenge.fromJson(response.data);
    } else {
      throw Exception(
          'failed to get user security question ${response.statusCode}');
    }
  }

  Future postSecurityQNA(Challenge result) async {
    final response = await _dio
        .post(
          '/$questionEndpoint/user/',
          options: Options(contentType: Headers.jsonContentType),
          data: result.toJson(),
        )
        .onError(
            (error, stackTrace) => throw Exception('Something went Wrong'));

    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw Exception('failed to post questions ${response.statusCode}');
    }
  }

  Future postFcmToken(String user, String fcmToken) async {
    final response = await _dio.post(
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
      throw Exception('failed to post token ${response.statusCode}');
    }
  }

  Future<String> postChangePassword(
      String oldPass, String newPass, String token) async {
    final response = await _dio.post('/$passwordChangeEndpoint/',
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
      throw Exception('failed to change new password');
    }
  }

  Future<String> getPasswordReset(String email, String token) async {
    final response = await _dio.get(
      '/$passwordResetEndpoint/$email',
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      ),
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw Exception('failed to reset password');
    }
  }
}
