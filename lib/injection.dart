import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/repositories/repository_impl.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/news_detail_notifier.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/provider/question_notifier.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/utils/network_info_impl.dart';

import 'data/datasources/preferences/preferences_helper.dart';
import 'domain/usecases/get_saved_feeds.dart';
import 'domain/usecases/put_fcm_token.dart';
import 'domain/usecases/remove_feed.dart';

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

  // bloc
  locator.registerFactory(
    () => AboutCubit(),
  );
  locator.registerFactory(
    () => SavedFeedCubit(locator()),
  );
  locator.registerFactory(
    () => HistoryCubit(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => LoginCubit(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => RegisterCubit(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => PasswordCubit(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => QuestionCubit(
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => ReportCubit(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => DetailCubit(
      locator(),
    ),
  );
  locator.registerFactory(
        () => ItemCubit(
      locator(),
      locator(),
      locator(),
    ),
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
      ..options.sendTimeout = 60 * 1000
      ..options.validateStatus = (int? status) => status != null && status > 0;
    // ..interceptors.add(LogInterceptor())
  });
  locator.registerLazySingleton(() => DataConnectionChecker());
}
