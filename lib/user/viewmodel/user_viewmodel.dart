import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trx/product/enum/view_state.dart';
import 'package:trx/user/model/user_login_model.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/service/user_service.dart';

class UserViewmodel with ChangeNotifier implements UserService {
  UserLoginModel? userLoginModel;
  final _service = UserService.instance;

  ViewState _loginState = ViewState.idle;
  String? _token;

  ViewState get loginState => _loginState;

  set loginState(ViewState loginState) {
    _loginState = loginState;
    notifyListeners();
  }

  UserModel? userModel;
  String? get token => _token;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
    String? userToken,
  }) async {
    loginState = ViewState.busy;
    try {
      final response = await _service.login(
        email: email,
        password: password,
        userToken: userToken,
      );

      if (response != null) {
        userModel = response;
        // _token = userLoginModel?.token;
        return userModel;
      } else {
        throw Exception('Giriş başarısız. Yanıt null döndü.');
      }
    } on DioException catch (e) {
      print(e.response);

      return null;
    } finally {
      loginState = ViewState.idle;
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
    loginState = ViewState.busy;
    try {
      final response = await _service.register(
        fullName: fullName,
        userName: userName,
        email: email,
        password: password,
        //macAddress: macAddress
      );

      return response;
    } on DioException catch (e) {
      print('000DioException: ${e.message}');
      return null;
    } finally {
      loginState = ViewState.idle;
    }
  }
}
