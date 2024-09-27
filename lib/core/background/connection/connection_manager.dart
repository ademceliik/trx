import 'dart:io';

class ConnectionManager {
  // internet erisimi var mi
  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      var res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return res;
    } on SocketException catch (_) {
      return false;
    }
  }
}
