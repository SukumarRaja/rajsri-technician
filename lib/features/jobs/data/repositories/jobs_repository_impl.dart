import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../datasources/jobs_remote_datasource.dart';
import '../models/job_action_request.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({required this.remoteDataSource});

  Future<Either<Failure, void>> _performAction(Future<void> Function() action) async {
    try {
      await action();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Action failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptJob(int jobId) {
    return _performAction(() => remoteDataSource.acceptJob(JobActionRequest(jobId: jobId)));
  }

  @override
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason}) {
    return _performAction(() => remoteDataSource.rejectJob(JobActionRequest(jobId: jobId, notes: reason)));
  }

  @override
  Future<Either<Failure, void>> startJob(int jobId) {
    return _performAction(() => remoteDataSource.startJob(JobActionRequest(jobId: jobId)));
  }

  @override
  Future<Either<Failure, void>> completeJob(int jobId, {String? notes}) {
    return _performAction(() => remoteDataSource.completeJob(JobActionRequest(jobId: jobId, notes: notes)));
  }
}
