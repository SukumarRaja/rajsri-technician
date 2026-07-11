import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/job_action_request.dart';

part 'jobs_remote_datasource.g.dart';

@RestApi()
abstract class JobsRemoteDataSource {
  factory JobsRemoteDataSource(Dio dio, {String baseUrl}) = _JobsRemoteDataSource;

  @POST('/technician/accept')
  Future<void> acceptJob(@Body() JobActionRequest request);

  @POST('/technician/reject')
  Future<void> rejectJob(@Body() JobActionRequest request);

  @POST('/technician/start')
  Future<void> startJob(@Body() JobActionRequest request);

  @POST('/technician/complete')
  Future<void> completeJob(@Body() JobActionRequest request);
}
