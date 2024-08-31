import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();

  test("user should be register", () async {
    var result;
    String email = "adem10@adem"; // try unique email
    String password = "adem"; // should be longer 6 letter
    String fullName = "adem";
    String userName = "adem002"; // try unique username
    result = await uvm.register(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      // macAddress: macAdressController.text,
    );
    expect(result, false);
  });
}
