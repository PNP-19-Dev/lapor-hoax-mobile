import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:laporhoax/data/datasources/db/database_helper.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/data/repositories/repository_impl.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/provider/preferences_notifier.dart';
import 'package:laporhoax/presentation/provider/saved_feed_notifier.dart';

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
    () => SavedFeedNotifier(getFeeds: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetFeeds(locator()));
  locator.registerLazySingleton(() => SaveFeed(locator()));
  locator.registerLazySingleton(() => RemoveFeed(locator()));
  locator.registerLazySingleton(() => GetSavedFeeds(locator()));

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
