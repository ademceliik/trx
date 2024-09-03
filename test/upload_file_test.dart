import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIxIiwidW5pcXVlX25hbWUiOiJ5dXN1ZmFsaSIsIm5iZiI6MTcyNTM0NjQ3OCwiZXhwIjoxNzI1NDMyODc4LCJpYXQiOjE3MjUzNDY0NzgsImlzcyI6Inl1c3VmYWxpYmVrY2kuY29tIiwiYXVkIjoieXVzdWZhbGlkZW5lbWUifQ.i1tQwelMpDyYoKHgsKv7Pvy-lr2gx5DM4PwYVfJnTSo";
  test("upload db", () async {
    var result = await uvm.uploadFile(
        filePath: "/Users/traxnav/Desktop/test.db", userToken: token);
    expect(result, false);
  });
}
