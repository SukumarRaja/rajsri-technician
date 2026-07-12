import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> login(String phone, String password) async {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.login(LoginRequest(phone: phone, password: password));
      await localDataSource.saveToken(response.token);
      return response.user;
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return ErrorHandler.execute(() async {
      try {
        final token = localDataSource.getToken();
        if (token != null && token.isNotEmpty) {
          await remoteDataSource.logout();
        }
      } finally {
        await localDataSource.clearToken();
      }
    });
  }

  @override
  Future<bool> checkAuthStatus() async {
    final token = localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
