import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/complete_job_request.dart';
import '../../data/models/job_detail_response.dart';
import '../../data/models/job_response.dart';
import '../../data/models/update_services_request.dart';

abstract class JobsRepository {
  Future<Either<Failure, JobsData>> getJobs({
    String? search,
    String? status,
    int? perPage,
    int? todayPage,
    int? upcomingPage,
  });
  Future<Either<Failure, PaginatedJobs>> getHistory({
    int? page,
    String? status,
    String? search,
    int? perPage,
  });
  Future<Either<Failure, JobDetailModel>> getJobDetail(int jobId);
  Future<Either<Failure, void>> acceptJob(int jobId);
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason});
  Future<Either<Failure, void>> startJob(int jobId, {String? beforeNotes});
  Future<Either<Failure, void>> completeJob(
    int jobId, {
    String? afterNotes,
    String? notes,
    List<String>? images,
    List<PartUsed>? partsUsed,
    bool? paymentReceived,
    double? paymentAmount,
    String? paymentMethod,
  });
  Future<Either<Failure, void>> cancelJob(int jobId, String reason);
  Future<Either<Failure, void>> updateServices(
    int jobId,
    List<UpdateServiceItem> services,
  );
}
