import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../datasources/jobs_remote_datasource.dart';
import '../models/job_action_request.dart';
import '../models/complete_job_request.dart';
import '../models/job_response.dart';

import '../../../../core/error/error_handler.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobsData>> getJobs({
    String? search,
    String? status,
    int? todayPage,
    int? upcomingPage,
  }) {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getJobs(
        search: search,
        status: status,
        todayPage: todayPage,
        upcomingPage: upcomingPage,
      );
      return response.data;
    });
  }

  @override
  Future<Either<Failure, PaginatedJobs>> getHistory({
    int? page,
    String? status,
    String? search,
  }) {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getHistory(
        page: page,
        status: status,
        search: search,
      );
      return response.data;
    });
  }

  @override
  Future<Either<Failure, void>> acceptJob(int jobId) {
    return ErrorHandler.execute(() => remoteDataSource.acceptJob(JobActionRequest(jobId: jobId)));
  }

  @override
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason}) {
    return ErrorHandler.execute(() => remoteDataSource.rejectJob(JobActionRequest(jobId: jobId, notes: reason)));
  }

  @override
  Future<Either<Failure, void>> startJob(int jobId) {
    return ErrorHandler.execute(() => remoteDataSource.startJob(jobId));
  }

  @override
  Future<Either<Failure, void>> completeJob(
    int jobId, {
    String? notes,
    List<String>? images,
    List<PartUsed>? partsUsed,
  }) {
    return ErrorHandler.execute(
      () async {
        var formData = FormData();
        if (notes != null && notes.isNotEmpty) {
          formData.fields.add(MapEntry('notes', notes));
        }

        if (images != null) {
          for (int i = 0; i < images.length; i++) {
            formData.files.add(
              MapEntry(
                'images[$i]',
                await MultipartFile.fromFile(images[i]),
              ),
            );
          }
        }

        if (partsUsed != null) {
          for (int i = 0; i < partsUsed.length; i++) {
            formData.fields.add(MapEntry('parts_used[$i][name]', partsUsed[i].name));
            formData.fields.add(MapEntry('parts_used[$i][quantity]', partsUsed[i].quantity.toString()));
            formData.fields.add(MapEntry('parts_used[$i][price]', partsUsed[i].price.toString()));
          }
        }

        return remoteDataSource.completeJob(jobId, formData);
      },
    );
  }

  @override
  Future<Either<Failure, void>> cancelJob(int jobId, String reason) {
    return ErrorHandler.execute(() => remoteDataSource.cancelJob(jobId, {'reason': reason}));
  }
}
