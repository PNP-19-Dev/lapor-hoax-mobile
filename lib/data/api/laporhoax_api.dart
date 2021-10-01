import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/data/model/otp_status.dart';
import 'package:laporhoax/data/model/report.dart';
import 'package:laporhoax/data/model/user.dart';
import 'package:laporhoax/data/model/user_register.dart';
import 'package:laporhoax/data/model/user_status.dart';
import 'package:laporhoax/data/model/user_token.dart';

class LaporhoaxApi {
  static final String baseUrl = 'https://laporhoaxpolda.herokuapp.com';
  static final String loginEndpoint = 'auth/api/login';
  static final String registerEndpoint = 'auth/api/register';
  static final String reportsEndpoint = 'api/reports';
  static final String feedsEndpoint = 'api/feeds';
  static final String isActiveEndpoint = 'isactive';
  static final String verifyOtpEndpoint = 'verifyotp';

  final Client client;

  LaporhoaxApi(this.client);

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "accept": "*/*"
  };

  // return token
  Future<UserToken> postLogin(String username, String password) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/$loginEndpoint/'),
          headers: headers,
          body: jsonEncode(
            <String, String>{
              "username": username,
              "password": password,
            },
          ),
        )
        .onError((error, stackTrace) => throw Exception('No Internet'));

    if (response.statusCode == 200) {
      print(response.body);
      return UserToken.fromJson(jsonDecode(response.body));
    } else {
      print('Response : ${response.statusCode}');
      throw Exception(
          '\nStatus: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  Future<dynamic> postRegister(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$registerEndpoint/'),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserRegister.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register : ${response.statusCode}');
    }
  }

  // return status
  Future<UserStatus> isActive(String key) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$isActiveEndpoint/'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'key': key,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to validate');
    }
  }

  Future<OtpStatus> verifyOtp(String email, String otp) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$verifyOtpEndpoint/'),
      headers: headers,
      body: jsonEncode(
        <String, String>{
          'email': email,
          'otp': otp,
        },
      ),
    );

    if (response.statusCode == 200) {
      return OtpStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to verify');
    }
  }

  Future<dynamic> postReport(Report report) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$reportsEndpoint'),
      headers: headers,
      body: jsonEncode(report.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Report> getReport() async {
    final response = await client.get(
      Uri.parse('$baseUrl/$reportsEndpoint/'),
    );

    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load report');
    }
  }

  Future<List<Feed>> getFeeds() async {
    final response = await client.get(Uri.parse('$baseUrl/$feedsEndpoint/'));

    if (response.statusCode == 200) {
      return feedFromJson(response.body);
    } else {
      throw Exception('Failed to load report');
    }
  }

  Future<Feed> getFeedById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$feedsEndpoint/$id'));

    if (response.statusCode == 200) {
      return Feed.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load feed by id');
    }
  }
}
