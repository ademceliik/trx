import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();

  test("user should be register", () async {
    var result;
    String email = "adem13@adem"; // try unique email
    String password = "ademad"; // should be longer 6 letter
    String fullName = "adem";
    String userName = "adem005"; // try unique username
    result = await uvm.register(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      // macAddress: macAdressController.text,
    );
/*     List<Map> expected = [
      {
        'code': 'DuplicateUserName',
        'description': 'Username \'adem002\' is already taken.'
      },
      {
        'code': 'DuplicateEmail',
        'description': 'Email \'adem10@adem\' is already taken.'
      }
    ]; */
    expect(result, true);
  });
}
