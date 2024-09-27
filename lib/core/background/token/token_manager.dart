import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  late String? token;

  // kayitli token varsa tokeni atar
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('user_token');
  }

  // token gecersizse tokeni sil
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }

  // token gecerli kontrolu
  Future<dynamic> checkToken() async {
    await getToken();
    if (token != null) {
      var decodedDate = JwtDecoder.getExpirationDate(token!);
      if (decodedDate.isAfter(DateTime.now())) {
        return token;
      }

      // token gecerli degilse tokeni sil
      else {
        deleteToken();
        return false;
      }
    }
    return null;
  }
}
