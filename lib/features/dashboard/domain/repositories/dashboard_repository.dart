import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/dashboard_response.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboard();
}
