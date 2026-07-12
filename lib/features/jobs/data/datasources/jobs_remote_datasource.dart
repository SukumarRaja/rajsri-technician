import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/job_action_request.dart';
import '../models/complete_job_request.dart';
import '../models/job_response.dart';

part 'jobs_remote_datasource.g.dart';

@RestApi()
abstract class JobsRemoteDataSource {
  factory JobsRemoteDataSource(Dio dio, {String baseUrl}) = _JobsRemoteDataSource;

  @GET('/technician/jobs')
  Future<JobsResponse> getJobs({
    @Query('search') String? search,
    @Query('status') String? status,
    @Query('today_page') int? todayPage,
    @Query('upcoming_page') int? upcomingPage,
  });

  @GET('/technician/history')
  Future<HistoryResponse> getHistory({
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('search') String? search,
  });

  @POST('/technician/accept')
  Future<void> acceptJob(@Body() JobActionRequest request);

  @POST('/technician/reject')
  Future<void> rejectJob(@Body() JobActionRequest request);

  @POST('/technician/jobs/{jobId}/start')
  Future<void> startJob(@Path('jobId') int jobId);

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
}
