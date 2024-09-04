import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIzIiwidW5pcXVlX25hbWUiOiJhZGVtMDAxIiwibmJmIjoxNzI1NDMzMjYwLCJleHAiOjE3MjU1MTk2NjAsImlhdCI6MTcyNTQzMzI2MCwiaXNzIjoieXVzdWZhbGliZWtjaS5jb20iLCJhdWQiOiJ5dXN1ZmFsaWRlbmVtZSJ9.mlnd5iSPzY8o8yFyakDiOPNk9parGtLRXPVbR4-5jIk";
  test("get user files", () async {
    var result = await uvm.getUserFiles(userToken: token);
    expect(result, false);
  });
}
