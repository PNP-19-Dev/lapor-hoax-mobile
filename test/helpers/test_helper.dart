import 'package:dio/dio.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/network_info_impl.dart';
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
