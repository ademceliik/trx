import 'package:dio/dio.dart';
import 'package:trx/core/init/network_manager.dart';
import 'package:trx/product/enum/service_paths.dart';
import 'package:trx/user/model/user_model.dart'; // Ensure this imports the correct model
import 'package:trx/user/service/i_user_service.dart';

class UserService extends IUserService {
  static UserService? _instance;

  static UserService get instance => _instance ??= UserService._init();

  UserService._init();

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
    String? userToken,
  }) async {
    try {
      final response = await NetworkManager.instance?.dioPost<UserModel>(
        ServicePaths.login.path,
        data: {"email": email, "password": password},
        options: Options(headers: {"Authorization": "Bearer $userToken"}),
        model: UserModel(),
      );
      final mdl = UserModel();
      mdl.user = response;
      // Check if response is of type UserLoginModel
      return mdl;
    } on DioException catch (e) {
      // Log error response
      print(
          "DioException during login: ${e.response?.statusCode} ${e.message}");
      throw Exception("Giriş başarısız. ${e.message}");
    } catch (e) {
      // Catch any other exceptions
      print("Unexpected error during login: $e");
      throw Exception("Giriş başarısız. Lütfen tekrar deneyin.");
    }
  }

  @override
  Future<dynamic> register({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    // required String macAddress
  }) async {
    try {
      final response = await NetworkManager.instance?.dioPost<UserModel>(
        ServicePaths.register.path,
        data: {
          "fullName": fullName,
          "userName": userName,
          "email": email,
          "password": password,
          //     "macAddress": macAddress
        },
        model: UserModel(),
      );

      //  if (response) {
      return response;
      //  } else {
      // throw Exception("Kayıt başarısız. Yanıt beklenen formatta değil.");
      //   }
    } on DioException catch (e) {
      // Log error response
      print(
          "DioException during registration: ${e.response?.statusCode} ${e.message}");
      return e.response?.data;
      //throw Exception("Kayıt başarısız. ${e.message}");
      //throw Exception(e.response?.data[1]["description"]);
    } catch (e) {
      // Catch any other exceptions
      print("Unexpected error during registration: $e");
      throw Exception("Kayıt başarısız. Lütfen tekrar deneyin.");
    }
  }
}
