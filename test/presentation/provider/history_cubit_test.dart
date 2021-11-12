import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'history_cubit_test.mocks.dart';

@GenerateMocks([GetReports, DeleteReport])
void main() {
  late HistoryCubit bloc;
  late MockGetReports _query;
  late MockDeleteReport _delete;

  setUp(() {
    _query = MockGetReports();
    _delete = MockDeleteReport();
    bloc = HistoryCubit(_query, _delete);
  });

  group('Fetch History', () {
    const token = 'token';
    const id = 1;
    final tokenId = TokenId(id, token);

    blocTest<HistoryCubit, HistoryState>(
      'Should get data when usecase is called',
      build: () {
        when(_query.execute(token, id))
            .thenAnswer((_) async => Right([testReport]));
        return bloc;
      },
      act: (cubit) => cubit.getHistory(tokenId),
      verify: (cubit) => cubit.getHistory(tokenId),
      expect: () => [
        HistoryLoading(),
        HistoryHasData([testReport]),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'Should return error callback when usecase is called',
      build: () {
        when(_query.execute(token, id))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.getHistory(tokenId),
      verify: (cubit) => cubit.getHistory(tokenId),
      expect: () => [HistoryLoading(), HistoryError('Failure')],
    );
  });

  group('Remove Report', () {
    const token = 'token';
    const id = 1;
    const status = 'belum diproses';
    final tokenId = TokenId(id, token);
    var reports = <Report>[];

    blocTest<HistoryCubit, HistoryState>(
      'Should get data when usecases is called',
      build: () {
        when(_delete.execute(token, id))
            .thenAnswer((_) async => Right('Success'));
        return bloc;
      },
      act: (cubit) => cubit.removeReport(tokenId, status),
      verify: (cubit) => cubit.removeReport(tokenId, status),
      expect: () => [
        HistoryLoading(),
        HistoryDeleteSomeData(reports, 'Success'),
      ],
    );
  });
}
