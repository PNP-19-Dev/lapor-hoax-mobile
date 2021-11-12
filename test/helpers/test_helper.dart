/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.58
 */

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/preferences/preferences_helper.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/utils/network_info_impl.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  Repository,
  RemoteDataSource,
  LocalDataSource,
  DatabaseHelper,
  PreferencesHelper,
  DataConnectionChecker,
  NetworkInfo,
  DetailCubit,
  FeedCubit,
  HistoryCubit,
  ItemCubit,
  LoginCubit,
  PasswordCubit,
  QuestionCubit,
  RegisterCubit,
  ReportCubit,
  SavedFeedCubit,
  AboutCubit,
], customMocks: [
  MockSpec<Dio>(as: #MockDio)
])
void main() {}
