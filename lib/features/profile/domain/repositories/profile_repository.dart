import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? profileImagePath,
  });

  Future<Either<Failure, void>> deleteAccount();
}
