import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trx/product/enum/view_state.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/service/user_service.dart';

class UserViewmodel with ChangeNotifier implements UserService {
  UserModel? userModel;
  final _service = UserService.instance;

  ViewState _loginState = ViewState.idle;

  ViewState get loginState => _loginState;

  set loginState(ViewState loginState) {
    _loginState = loginState;
    notifyListeners();
  }

  @override
  Future login({
    required String email,
    required String password,
  }) async {
    loginState = ViewState.busy;
    try {
      userModel = await _service.login(
        email: email,
        password: password,
      );
    } on DioException catch (e) {
      print(e);
      return false;
    } finally {
      loginState = ViewState.idle;
    }
  }
}
