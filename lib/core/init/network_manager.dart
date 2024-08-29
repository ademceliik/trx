import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:trx/core/base/base_model.dart';

import '../../../product/enum/service_paths.dart';

class NetworkManager {
  NetworkManager._init() {
    final baseOptions = BaseOptions(baseUrl: ServicePaths.base.path);
    _dio = Dio(baseOptions);
  }

  static NetworkManager? _instance;

  static NetworkManager? get instance => _instance ??= NetworkManager._init();
  Dio _dio = Dio();

  Future<dynamic> dioGet<T extends BaseModel>(
    String path, {
    T? model,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response = await _dio.get(path,
        options: options, queryParameters: queryParameters);

    log(response.data.toString());
    switch (response.statusCode) {
      case 200:
        final responseBody = response.data;
        if ((responseBody is List) && model != null) {
          return responseBody.map((e) => model.fromJson(e)).toList();
        } else if ((responseBody is Map) && model != null) {
          return model.fromJson(responseBody as Map<String, dynamic>);
        } else {
          return responseBody;
        }
      default:
    }
  }

  Future<dynamic> dioPost<T extends BaseModel>(String path,
      {T? model, dynamic data, Options? options}) async {
    Response response = await _dio.post(path, options: options, data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.data;
      if ((responseBody is List) && model != null) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if ((responseBody is Map) && model != null) {
        return model.fromJson(responseBody as Map<String, dynamic>);
      } else {
        return responseBody;
      }
    } else {
      if (response.data is Map && response.data.containsKey("error")) {
        return response.data["error"];
      }
    }
  }

  Future<dynamic> dioPatch<T extends BaseModel>(String path,
      {T? model, dynamic data, Options? options}) async {
    Response response = await _dio.patch(path, options: options, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.data;
      if ((responseBody is List) && model != null) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if ((responseBody is Map) && model != null) {
        return model.fromJson(responseBody as Map<String, dynamic>);
      } else {
        return responseBody;
      }
    }
  }

  Future<dynamic> dioPut<T extends BaseModel>(String path,
      {T? model, dynamic data, Options? options}) async {
    Response response = await _dio.put(path, options: options, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.data;
      if ((responseBody is List) && model != null) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if ((responseBody is Map) && model != null) {
        return model.fromJson(responseBody as Map<String, dynamic>);
      } else {
        return responseBody;
      }
    }
  }

  Future<dynamic> dioDelete<T extends BaseModel>(String path,
      {T? model, dynamic data, Options? options}) async {
    Response response = await _dio.delete(path, options: options, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.data;
      if ((responseBody is List) && model != null) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if ((responseBody is Map) && model != null) {
        return model.fromJson(responseBody as Map<String, dynamic>);
      } else {
        return responseBody;
      }
    }
  }
}
