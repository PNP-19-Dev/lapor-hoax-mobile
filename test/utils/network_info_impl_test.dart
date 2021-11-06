import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/utils/network_info_impl.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecker mockDataConnectionChecker;

 setUp((){
   mockDataConnectionChecker = MockDataConnectionChecker();
   networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
 });

 test('Should return true when device is online', () async {
   // arrange
   when(mockDataConnectionChecker.hasConnection)
       .thenAnswer((realInvocation) async => true);
   // act
   final result = await networkInfo.isConnected;
   // assert
   expect(result, true);
 });
}