import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(String phone, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
  Future<bool> checkAuthStatus();
}
