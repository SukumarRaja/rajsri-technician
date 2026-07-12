import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../auth/data/models/user_model.dart';

part 'profile_remote_datasource.g.dart';

@RestApi()
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio, {String baseUrl}) = _ProfileRemoteDataSource;

  @GET(ApiEndpoints.profile)
  Future<ProfileResponse> getProfile();

  @POST(ApiEndpoints.profile)
  Future<ProfileResponse> updateProfile(@Body() FormData request);

  @DELETE(ApiEndpoints.deleteAccount)
  Future<void> deleteAccount();
}
