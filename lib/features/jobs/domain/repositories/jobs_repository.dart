import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class JobsRepository {
  Future<Either<Failure, void>> acceptJob(int jobId);
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason});
  Future<Either<Failure, void>> startJob(int jobId);
  Future<Either<Failure, void>> completeJob(int jobId, {String? notes});
}
