import 'dart:io';

import 'package:core/core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:feed/feed.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => FeedNotifier(getFeeds: locator()),
  );
  locator.registerFactory(
    () => ReportNotifier(
      getReports: locator(),
      postReport: locator(),
      deleteReport: locator(),
      getCategories: locator(),
    ),
  );
  locator.registerFactory(
    () => UserNotifier(
      getUser: locator(),
      getPasswordReset: locator(),
      postFCMToken: locator(),
      postChangePassword: locator(),
      postUserChallenge: locator(),
      removeSessionData: locator(),
      saveSessionData: locator(),
      getSessionData: locator(),
      getSessionStatus: locator(),
      postLogin: locator(),
      postRegister: locator(),
      putFCMToken: locator(),
    ),
  );
  locator.registerFactory(
    () => QuestionNotifier(
      getQuestions: locator(),
      getUserChallenge: locator(),
    ),
  );
  locator.registerFactory(
    () => NewsDetailNotifier(
      getFeedSaveStatus: locator(),
      removeFeed: locator(),
      saveFeed: locator(),
      getFeedDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => SavedNewsNotifier(getSavedFeeds: locator()),
  );

  // use case
  locator.registerLazySingleton(() => DeleteReport(locator()));
  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => GetFeedDetail(locator()));
  locator.registerLazySingleton(() => GetFeedSaveStatus(locator()));
  locator.registerLazySingleton(() => GetFeeds(locator()));
  locator.registerLazySingleton(() => GetPasswordReset(locator()));
  locator.registerLazySingleton(() => GetQuestions(locator()));
  locator.registerLazySingleton(() => GetReports(locator()));
  locator.registerLazySingleton(() => GetSavedFeeds(locator()));
  locator.registerLazySingleton(() => GetSessionData(locator()));
  locator.registerLazySingleton(() => GetSessionStatus(locator()));
  locator.registerLazySingleton(() => GetUser(locator()));
  locator.registerLazySingleton(() => GetUserChallenge(locator()));
  locator.registerLazySingleton(() => PostChangePassword(locator()));
  locator.registerLazySingleton(() => PostFCMToken(locator()));
  locator.registerLazySingleton(() => PutFCMToken(locator()));
  locator.registerLazySingleton(() => PostLogin(locator()));
  locator.registerLazySingleton(() => PostRegister(locator()));
  locator.registerLazySingleton(() => PostReport(locator()));
  locator.registerLazySingleton(() => PostUserChallenge(locator()));
  locator.registerLazySingleton(() => RemoveFeed(locator()));
  locator.registerLazySingleton(() => RemoveSessionData(locator()));
  locator.registerLazySingleton(() => SaveFeed(locator()));
  locator.registerLazySingleton(() => SaveSessionData(locator()));

  // repository
  locator.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(
      databaseHelper: locator(),
      preferencesHelper: locator(),
    ),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // shared preferences
  locator.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper());

  // external
  locator.registerLazySingleton(() {
    return Dio()
      ..options.headers.addAll({
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br'
      })
      ..options.baseUrl = RemoteDataSourceImpl.baseUrl
      ..options.validateStatus = (int? status) => status != null && status > 0;
    // ..interceptors.add(LogInterceptor())
  });
  locator.registerLazySingleton(() => DataConnectionChecker());
}
