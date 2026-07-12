import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getProfile() {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getProfile();
      return response.data;
    });
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? profileImagePath,
  }) {
    return ErrorHandler.execute(() async {
      final formData = FormData();
      
      if (name != null) formData.fields.add(MapEntry('name', name));
      if (email != null) formData.fields.add(MapEntry('email', email));
      if (mobile != null) formData.fields.add(MapEntry('mobile', mobile));
      
      if (profileImagePath != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(profileImagePath),
          ),
        );
      }
      
      final response = await remoteDataSource.updateProfile(formData);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    return ErrorHandler.execute(() async {
      await remoteDataSource.deleteAccount();
    });
  }
}
