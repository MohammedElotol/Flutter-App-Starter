import 'package:flutter_app_starter/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
main() {
  late MockInternetConnectionChecker mockConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockConnectionChecker);
  });

  group('isConnected', () {
    test('Should forward the call to InternetConnectionChecker', () async {
      final tHasConnection = Future.value(true);
      when(mockConnectionChecker.hasConnection).thenAnswer((realInvocation) => tHasConnection);
      final result = networkInfoImpl.isConnected;
      verify(mockConnectionChecker.hasConnection);
      expect(result, tHasConnection);
    });
  });
}
