import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
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
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(LoginRequest(email: email, password: password));
      await localDataSource.saveToken(response.token);
      return Right(response.user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearToken();
      return const Right(null);
    } catch (e) {
      await localDataSource.clearToken(); // Clear token even if API fails
      return const Right(null);
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    final token = localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
