import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:laporhoax/data/model/report.dart';
import 'package:laporhoax/data/model/user.dart';
import 'package:laporhoax/data/model/user_status.dart';

class LaporhoaxApi {
  static final String baseUrl = 'http://laporhoaxpnp.herokuapp.com/api';
  static final String loginEndpoint = 'login';
  static final String isActiveEndpoint = 'isacive';
  static final String registerEndpoint = 'register';
  static final String postReportEndpoint = 'postreport';
  static final String getReportEndpoint = 'getreport';

  final Client client;

  LaporhoaxApi(this.client);

  // return token
  Future<String> postLogin(String username, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$loginEndpoint/'),
      body: jsonEncode(
        <String, String>{
          'username': username,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to login');
    }
  }

  // return status
  Future<UserStatus> isActive(String key) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$isActiveEndpoint/'),
      headers: <String, String>{
        'Content-Tyle': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': key,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<dynamic> postRegister(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$loginEndpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: user.toJson(),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<dynamic> postReport(Report report) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$postReportEndpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: report.toJson(),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Report> getReport() async {
    final response = await client.get(
      Uri.parse('$baseUrl/$getReportEndpoint/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load report');
    }
  }
}
