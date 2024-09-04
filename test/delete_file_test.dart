import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIzIiwidW5pcXVlX25hbWUiOiJhZGVtMDAxIiwibmJmIjoxNzI1NDMzMjYwLCJleHAiOjE3MjU1MTk2NjAsImlhdCI6MTcyNTQzMzI2MCwiaXNzIjoieXVzdWZhbGliZWtjaS5jb20iLCJhdWQiOiJ5dXN1ZmFsaWRlbmVtZSJ9.mlnd5iSPzY8o8yFyakDiOPNk9parGtLRXPVbR4-5jIk";
  test("delete db file", () async {
    var fileList = await uvm.getUserFiles(userToken: token);

    var result = await uvm.deleteFile(userToken: token, fileName: fileList[0]);
    expect(result, false);
  });
}
