import 'package:flutter_test/flutter_test.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

void main() {
  UserViewmodel uvm = UserViewmodel();

  test("user should be register", () async {
    var result;
    String email = ""; //adem2@adem"; // try unique email
    String password = ""; //ademadem"; // should be longer 6 letter
    String fullName = ""; //adem";
    String userName = ""; //adem002"; // try unique username
    String macAddress = ""; //15:AD:14:B9:64";
    result = await uvm.register(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
      macAddress: macAddress,
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
