import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laporhoax/data/model/category.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/data/model/otp_status.dart';
import 'package:laporhoax/data/model/report.dart';
import 'package:laporhoax/data/model/user_data.dart';
import 'package:laporhoax/data/model/user_login.dart';
import 'package:laporhoax/data/model/user_register.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/data/model/user_status.dart';
import 'package:laporhoax/data/model/user_token.dart';

class LaporhoaxApi {
  static final String baseUrl = 'https://laporhoaxpolda.herokuapp.com';
  static final String loginEndpoint = 'auth/api/login';
  static final String registerEndpoint = 'auth/api/register';
  static final String getUserEndpint = 'auth/api/users/get';
  static final String reportsEndpoint = 'api/reports';
  static final String reportCatEndpoint = 'api/reports/cat';
  static final String feedsEndpoint = 'api/feeds';
  static final String isActiveEndpoint = 'isactive';
  static final String verifyOtpEndpoint = 'verifyotp';

  final Dio dio;

  LaporhoaxApi(this.dio) {
    dio.options.baseUrl = baseUrl;
    dio.options.validateStatus = (int? status) {
      return status != null && status > 0;
    };
    dio.options.headers = <String, String>{
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
    };
  }

  // return token
  Future<UserToken> postLogin(String username, String password) async {
    final response = await dio
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
    final response = await dio.post(
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
    final response = await dio.get('/$reportCatEndpoint');

    if (response.statusCode == 200) {
      return categoryFromJson(response.data);
    } else {
      throw Exception('gagal mendapatkan kategori');
    }
  }

  // return status
  Future<UserStatus> isActive(String key) async {
    final response = await dio.post(
      '/$isActiveEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: jsonEncode(<String, String>{
        'key': key,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Failed to validate');
    }
  }

  Future<OtpStatus> verifyOtp(String email, String otp) async {
    final response = await dio.post(
      '/$verifyOtpEndpoint/',
      options: Options(contentType: Headers.jsonContentType),
      data: jsonEncode(
        <String, String>{
          'email': email,
          'otp': otp,
        },
      ),
    );

    if (response.statusCode == 200) {
      return OtpStatus.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to verify');
    }
  }

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
      throw Exception('Failed to retrieve user data ${response.statusCode}');
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
          filename: report.img.name)
    });

    final response = await dio.post('/$reportsEndpoint/',
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

  Future<UserReport> getReport(String token, String id) async {
    final response = await dio.get(
      '/$reportsEndpoint/user/$id/',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      }),
    );

    if (response.statusCode == 200) {
      return UserReport.fromJson(response.data);
    } else {
      print('${response.statusCode}');
      throw Exception('Failed to load report ${response.data}');
    }
  }

  Future<Feeds> getFeeds({String page = ""}) async {
    var response = await dio.get('$baseUrl/$feedsEndpoint/');

    if (page.isNotEmpty) {
      response = await dio
          .get('$baseUrl/$feedsEndpoint', queryParameters: {'page': page});
    }

    if (response.statusCode == 200) {
      return Feeds.fromJson(response.data);
    } else {
      throw Exception('Failed to load report');
    }
  }

  Future<Feed> getFeedById(String id) async {
    final response = await dio.get('$baseUrl/$feedsEndpoint/$id');

    if (response.statusCode == 200) {
      return Feed.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to load feed by id');
    }
  }
}
