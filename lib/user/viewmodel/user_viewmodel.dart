import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trx/product/enum/view_state.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/service/user_service.dart';

class UserViewmodel with ChangeNotifier implements UserService {
  final _service = UserService.instance;
  final UserModel _userModel = UserModel();
  ViewState _loginState = ViewState.idle;
  String? _token;
  List? userFiles;
  void setUserFiles(files) {
    userFiles = files;
    notifyListeners();
  }

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    // notifyListeners();
  }

  ViewState get loginState => _loginState;

  set loginState(ViewState loginState) {
    _loginState = loginState;
    notifyListeners();
  }

  UserModel get userModel => _userModel;

  void setUser(User user) {
    _userModel.user = user;
    //notifyListeners();
  }

  @override
  Future<dynamic> login({
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
      if (response is Map) {
        return response;
      }
      if (response is bool) {
        return response;
      }
    } on DioException catch (e) {
      print(e.response);

      return null;
    } finally {
      loginState = ViewState.idle;
    }
  }

  @override
  Future<dynamic> register(
      {required String fullName,
      required String userName,
      required String email,
      required String password,
      required String macAddress}) async {
    loginState = ViewState.busy;
    try {
      final response = await _service.register(
          fullName: fullName,
          userName: userName,
          email: email,
          password: password,
          macAddress: macAddress);

      return response;
    } on DioException catch (e) {
      print('000DioException: ${e.message}');
      return null;
    } finally {
      loginState = ViewState.idle;
    }
  }

  @override
  Future<bool> uploadFile(
      {required String filePath, required String userToken}) async {
    try {
      final response =
          await _service.uploadFile(filePath: filePath, userToken: userToken);
      notifyListeners();
      return response;
    } on DioException catch (e) {
      print("Dosya yükleme sırasında hata: ${e.message}");
      throw Exception("Dosya yükleme başarısız. ${e.message}");
    }
  }

  @override
  Future<List> getUserFiles({required String userToken}) async {
    try {
      final response = await _service.getUserFiles(userToken: userToken);
      notifyListeners();
      return response;
    } on DioException catch (e) {
      print("Getirme sırasında hata: ${e.message}");
      return List.empty();
    }
  }

  @override
  Future<bool> deleteFile(
      {required String fileName, required String userToken}) async {
    try {
      final response =
          await _service.deleteFile(userToken: userToken, fileName: fileName);
      notifyListeners();
      return response;
    } on DioException catch (e) {
      print("Silme sırasında hata: ${e.message}");
      return false;
    }
  }
}
