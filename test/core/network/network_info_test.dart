import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/core/network/network_info.dart';

class MockConnectivity implements Connectivity {
  List<ConnectivityResult> mockResult = [ConnectivityResult.wifi];

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return mockResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('should return true when the connectivity is wifi', () async {
      mockConnectivity.mockResult = [ConnectivityResult.wifi];
      final result = await networkInfo.isConnected;
      expect(result, true);
    });

    test('should return true when the connectivity is mobile', () async {
      mockConnectivity.mockResult = [ConnectivityResult.mobile];
      final result = await networkInfo.isConnected;
      expect(result, true);
    });

    test('should return true when the connectivity is ethernet', () async {
      mockConnectivity.mockResult = [ConnectivityResult.ethernet];
      final result = await networkInfo.isConnected;
      expect(result, true);
    });

    test('should return false when the connectivity is none', () async {
      mockConnectivity.mockResult = [ConnectivityResult.none];
      final result = await networkInfo.isConnected;
      expect(result, false);
    });

    test('should return false when the connectivity list is empty', () async {
      mockConnectivity.mockResult = [];
      final result = await networkInfo.isConnected;
      expect(result, false);
    });
  });
}
