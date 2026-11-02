import 'dart:async';
import 'dart:io';

/// Checks actual internet reachability with a short DNS lookup.
/// A connected Wi-Fi/mobile network alone does not guarantee internet access.
class InternetService {
  const InternetService({this.timeout = const Duration(seconds: 3)});

  final Duration timeout;

  Future<bool> hasInternetConnection() async {
    try {
      final addresses = await InternetAddress.lookup('example.com')
          .timeout(timeout);
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}
