import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/complete_job_request.dart';
import '../../data/models/job_response.dart';

abstract class JobsRepository {
  Future<Either<Failure, JobsData>> getJobs({
    String? search,
    String? status,
    int? todayPage,
    int? upcomingPage,
  });
  Future<Either<Failure, PaginatedJobs>> getHistory({
    int? page,
    String? status,
    String? search,
  });
  Future<Either<Failure, void>> acceptJob(int jobId);
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason});
  Future<Either<Failure, void>> startJob(int jobId);
  Future<Either<Failure, void>> completeJob(
    int jobId, {
    String? notes,
    List<String>? images,
    List<PartUsed>? partsUsed,
  });
  Future<Either<Failure, void>> cancelJob(int jobId, String reason);
}
