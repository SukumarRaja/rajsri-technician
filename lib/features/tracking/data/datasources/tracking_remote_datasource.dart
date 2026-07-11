import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/tracking_request.dart';

part 'tracking_remote_datasource.g.dart';

@RestApi()
abstract class TrackingRemoteDataSource {
  factory TrackingRemoteDataSource(Dio dio, {String baseUrl}) = _TrackingRemoteDataSource;

  @POST('/tracking/update')
  Future<void> updateLocation(@Body() TrackingRequest request);
}
