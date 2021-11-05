import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/local_data_source.dart';
import 'package:core/data/datasources/preferences/preferences_helper.dart';
import 'package:core/data/datasources/remote_data_source.dart';
import 'package:core/domain/repositories/repository.dart';
import 'package:core/utils/network_info_impl.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  Repository,
  RemoteDataSource,
  LocalDataSource,
  DatabaseHelper,
  PreferencesHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<Dio>(as: #MockDio)
])
void main() {}
