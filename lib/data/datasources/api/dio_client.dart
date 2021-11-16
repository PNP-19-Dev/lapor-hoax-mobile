/*
 * Created by andii on 14/11/21 10.32
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 09.28
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  static DioClient? _dioClient;

  late Dio _dio;

  DioClient._instance(String _baseUrl, {Interceptors? interceptors}) {
    _dioClient = this;
    _dio = Dio();
    _dio
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = {
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br',
      };

    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: false));
    }
  }

  factory DioClient(String baseUrl, {Interceptors? interceptors}) =>
      _dioClient ?? DioClient._instance(baseUrl, interceptors: interceptors);

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        options: Options(headers: headers),
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
