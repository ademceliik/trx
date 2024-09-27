import 'package:flutter_test/flutter_test.dart';
import 'package:trx/core/background/connection/connection_manager.dart';

void main() {
  test("delete db file", () async {
    final connectionManager = ConnectionManager();
    var result = await connectionManager.isInternetConnected();

    expect(result, true);
  });
}
