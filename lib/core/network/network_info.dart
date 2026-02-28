abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // TODO: Implement actual connectivity check
  @override
  Future<bool> get isConnected => Future.value(true);
}
