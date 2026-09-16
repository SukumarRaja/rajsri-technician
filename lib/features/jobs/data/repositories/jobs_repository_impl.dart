import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../datasources/jobs_remote_datasource.dart';
import '../models/job_action_request.dart';
import '../models/complete_job_request.dart';
import '../models/job_detail_response.dart';
import '../models/job_response.dart';
import '../models/update_services_request.dart';

import '../../../../core/error/error_handler.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JobsData>> getJobs({
    String? search,
    String? status,
    int? perPage,
    int? todayPage,
    int? upcomingPage,
  }) {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getJobs(
        search: search,
        status: status,
        perPage: perPage,
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
    int? perPage,
  }) {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getHistory(
        page: page,
        status: status,
        search: search,
        perPage: perPage,
      );
      return response.data;
    });
  }

  @override
  Future<Either<Failure, JobDetailModel>> getJobDetail(int jobId) {
    return ErrorHandler.execute(() async {
      final response = await remoteDataSource.getJobDetail(jobId);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, void>> acceptJob(int jobId) {
    return ErrorHandler.execute(() => remoteDataSource.acceptJob(jobId));
  }

  @override
  Future<Either<Failure, void>> rejectJob(int jobId, {String? reason}) {
    return ErrorHandler.execute(() => remoteDataSource.rejectJob(JobActionRequest(jobId: jobId, notes: reason)));
  }

  @override
  Future<Either<Failure, void>> startJob(int jobId, {String? beforeNotes}) {
    return ErrorHandler.execute(() {
      final body = beforeNotes != null ? {'before_notes': beforeNotes} : null;
      return remoteDataSource.startJob(jobId, body);
    });
  }

  @override
  Future<Either<Failure, void>> completeJob(
    int jobId, {
    String? afterNotes,
    String? notes,
    List<String>? images,
    List<PartUsed>? partsUsed,
    bool? paymentReceived,
    double? paymentAmount,
    String? paymentMethod,
  }) {
    return ErrorHandler.execute(
      () async {
        var formData = FormData();
        final finalAfterNotes = afterNotes ?? notes;
        if (finalAfterNotes != null && finalAfterNotes.isNotEmpty) {
          formData.fields.add(MapEntry('after_notes', finalAfterNotes));
        }

        if (paymentReceived != null) {
          formData.fields.add(MapEntry('payment_received', paymentReceived ? '1' : '0'));
        }

        if (paymentAmount != null) {
          formData.fields.add(MapEntry('payment_amount', paymentAmount.toString()));
        }

        if (paymentMethod != null && paymentMethod.isNotEmpty) {
          formData.fields.add(MapEntry('payment_method', paymentMethod));
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
            if (partsUsed[i].productId != null) {
              formData.fields.add(MapEntry('parts_used[$i][product_id]', partsUsed[i].productId.toString()));
            } else if (partsUsed[i].name != null) {
              formData.fields.add(MapEntry('parts_used[$i][name]', partsUsed[i].name!));
            }
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

  @override
  Future<Either<Failure, void>> updateServices(
    int jobId,
    List<UpdateServiceItem> services,
  ) {
    return ErrorHandler.execute(() => remoteDataSource.updateServices(jobId, UpdateServicesRequest(services: services)));
  }
}
