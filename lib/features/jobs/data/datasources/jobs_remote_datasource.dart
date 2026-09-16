import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/job_action_request.dart';
import '../models/job_response.dart';
import '../models/job_detail_response.dart';
import '../models/update_services_request.dart';

part 'jobs_remote_datasource.g.dart';

@RestApi()
abstract class JobsRemoteDataSource {
  factory JobsRemoteDataSource(Dio dio, {String baseUrl}) = _JobsRemoteDataSource;

  @GET('/technician/jobs')
  Future<JobsResponse> getJobs({
    @Query('search') String? search,
    @Query('status') String? status,
    @Query('per_page') int? perPage,
    @Query('today_page') int? todayPage,
    @Query('upcoming_page') int? upcomingPage,
  });

  @GET('/technician/history')
  Future<HistoryResponse> getHistory({
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('per_page') int? perPage,
  });

  @GET('/technician/jobs/{jobId}')
  Future<JobDetailResponse> getJobDetail(@Path('jobId') int jobId);

  @POST('/technician/jobs/{jobId}/accept')
  Future<void> acceptJob(@Path('jobId') int jobId);

  @POST('/technician/reject')
  Future<void> rejectJob(@Body() JobActionRequest request);

  @POST('/technician/jobs/{jobId}/start')
  Future<void> startJob(
    @Path('jobId') int jobId,
    @Body() Map<String, dynamic>? body,
  );

  @POST('/technician/jobs/{jobId}/complete')
  Future<void> completeJob(
    @Path('jobId') int jobId,
    @Body() FormData request,
  );

  @POST('/technician/jobs/{jobId}/cancel')
  Future<void> cancelJob(
    @Path('jobId') int jobId,
    @Body() Map<String, dynamic> request,
  );

  @PUT('/technician/jobs/{jobId}/services')
  Future<void> updateServices(
    @Path('jobId') int jobId,
    @Body() UpdateServicesRequest request,
  );
}
