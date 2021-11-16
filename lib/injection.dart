/*
 * Created by andii on 17/11/21 00.28
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 23.41
 */

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:laporhoax/data/datasources/api/dio_client.dart';
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
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/domain/usecases/set_session.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/presentation/provider/dark_provider.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/profile_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/utils/network_info_impl.dart';

import 'data/datasources/preferences/preferences_helper.dart';
import 'domain/usecases/get_saved_feeds.dart';
import 'domain/usecases/put_fcm_token.dart';
import 'domain/usecases/remove_feed.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => AboutCubit(),
  );
  locator.registerFactory(
    () => FeedCubit(locator()),
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
    ),
  );
  locator.registerFactory(
    () => AccountCubit(
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
    () => ProfileCubit(
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
  locator.registerFactory(
    () => DarkProvider(
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
  locator.registerLazySingleton(() => SaveFeed(locator()));
  locator.registerLazySingleton(() => SetSession(locator()));

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
    () => RemoteDataSourceImpl(client: locator()),
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
  locator.registerLazySingleton(() => DioClient(baseUrl));
  locator.registerLazySingleton(() => DataConnectionChecker());
}
