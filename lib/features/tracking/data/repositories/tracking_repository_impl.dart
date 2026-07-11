import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';
import '../models/tracking_request.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;

  TrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updateLocation(double latitude, double longitude) async {
    try {
      await remoteDataSource.updateLocation(TrackingRequest(latitude: latitude, longitude: longitude));
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Failed to update location'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
