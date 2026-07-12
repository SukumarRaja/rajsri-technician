import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class TrackingRepository {
  Future<Either<Failure, void>> updateLocation(
    double latitude,
    double longitude,
    DateTime recordedAt,
  );
}
