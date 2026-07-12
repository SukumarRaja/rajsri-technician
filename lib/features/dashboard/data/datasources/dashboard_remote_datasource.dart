import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/dashboard_response.dart';

part 'dashboard_remote_datasource.g.dart';

@RestApi()
abstract class DashboardRemoteDataSource {
  factory DashboardRemoteDataSource(Dio dio, {String baseUrl}) = _DashboardRemoteDataSource;

  @GET(ApiEndpoints.dashboard)
  Future<DashboardResponse> getDashboard();
}
