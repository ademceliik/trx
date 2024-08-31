import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();

  test("user login", () async {
    var result;
    String email = "adem10@adem"; // try unique email
    String password = "ademade"; // should be longer 6 letter
    result = await uvm.login(
      email: email,
      password: password,
    );
    expect(result, false);
  });
}
