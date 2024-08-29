import 'package:trx/core/init/network_manager.dart';
import 'package:trx/product/enum/service_paths.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/service/i_user_service.dart';

class UserService extends IUserService {
  static UserService? _instance;

  static UserService get instance => _instance ??= UserService._init();

  UserService._init();
  @override
  Future login({
    required String email,
    required String password,
  }) async {
    return NetworkManager.instance?.dioPost(
      ServicePaths.login.path,
      data: {"email": email, "password": password},
      model: UserModel(),
    );
  }
}
