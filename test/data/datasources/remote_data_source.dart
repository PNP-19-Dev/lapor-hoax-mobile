import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late LocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockPreferencesHelper mockPreferencesHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockPreferencesHelper = MockPreferencesHelper();
    dataSource = LocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
      preferencesHelper: mockPreferencesHelper,
    );
  });
}
