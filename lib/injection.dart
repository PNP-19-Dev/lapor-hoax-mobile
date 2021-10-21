import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/repositories/repository_impl.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/provider/preferences_notifier.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/provider/saved_feed_notifier.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';

import 'data/datasources/preferences/preferences_helper.dart';
import 'domain/usecases/get_saved_feeds.dart';
import 'domain/usecases/remove_feed.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => PreferencesNotifier(
      preferencesHelper: locator(),
    ),
  );
  locator.registerFactory(
    () => FeedNotifier(
      getFeeds: locator(),
      getFeedSaveStatus: locator(),
      getSavedFeeds: locator(),
      removeFeed: locator(),
      saveFeed: locator(),
    ),
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
      getQuestions: locator(),
      getPasswordReset: locator(),
      postLogin: locator(),
      postRegister: locator(),
      postFCMToken: locator(),
      postChangePassword: locator(),
      postUserChallenge: locator(),
    ),
  );
  locator.registerFactory(
    () => SavedFeedNotifier(getFeeds: locator()),
  );

  // use case
  locator.registerLazySingleton(() => DeleteReport(locator()));
  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => GetFeedSaveStatus(locator()));
  locator.registerLazySingleton(() => GetFeeds(locator()));
  locator.registerLazySingleton(() => GetPasswordReset(locator()));
  locator.registerLazySingleton(() => GetQuestions(locator()));
  locator.registerLazySingleton(() => GetReports(locator()));
  locator.registerLazySingleton(() => GetSavedFeeds(locator()));
  locator.registerLazySingleton(() => GetUser(locator()));
  locator.registerLazySingleton(() => PostChangePassword(locator()));
  locator.registerLazySingleton(() => PostFCMToken(locator()));
  locator.registerLazySingleton(() => PostLogin(locator()));
  locator.registerLazySingleton(() => PostRegister(locator()));
  locator.registerLazySingleton(() => PostReport(locator()));
  locator.registerLazySingleton(() => PostUserChallenge(locator()));
  locator.registerLazySingleton(() => RemoveFeed(locator()));
  locator.registerLazySingleton(() => SaveFeed(locator()));

  // repository
  locator.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
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

  // shared preferences
  locator.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper());

  // external
  locator.registerLazySingleton(() => Dio());
}
