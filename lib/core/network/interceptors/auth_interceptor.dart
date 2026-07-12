import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;
  final VoidCallback? onUnauthorized;

  AuthInterceptor({required this.sharedPreferences, this.onUnauthorized});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final token = sharedPreferences.getString(AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        sharedPreferences.remove(AppConstants.tokenKey);
        onUnauthorized?.call();
      }
    }
    return super.onError(err, handler);
  }
}
