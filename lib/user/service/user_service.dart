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
  Future<dynamic> login({
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
      return response;
    } catch (e) {
      return false;
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

  // New method for file upload
  @override
  Future<void> uploadFile(
      {required String filePath, required String userToken}) async {
    try {
      final fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await NetworkManager.instance?.dioPost(
        ServicePaths.upload.path,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $userToken",
            "Content-Type": 'multipart/form-data',
            "accept": "*/*"
          },
          //contentType: 'multipart/form-data',
        ),
      );
      print("File uploaded successfully: ${response?.data}");
    } on DioException catch (e) {
      print(
          "DioException during file upload: ${e.response?.statusCode} ${e.message}");
      throw Exception("Dosya yükleme başarısız. ${e.message}");
    } catch (e) {
      print("Unexpected error during file upload: $e");
      throw Exception("Dosya yükleme başarısız. Lütfen tekrar deneyin.");
    }
  }
}
