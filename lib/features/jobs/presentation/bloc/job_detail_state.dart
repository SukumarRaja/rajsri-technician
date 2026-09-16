import 'package:equatable/equatable.dart';
import '../../data/models/job_detail_response.dart';

abstract class JobDetailState extends Equatable {
  const JobDetailState();

  @override
  List<Object?> get props => [];
}

class JobDetailInitial extends JobDetailState {}

class JobDetailLoading extends JobDetailState {}

class JobDetailLoaded extends JobDetailState {
  final JobDetailModel jobDetail;

  const JobDetailLoaded(this.jobDetail);

  @override
  List<Object?> get props => [jobDetail];
}

class JobDetailError extends JobDetailState {
  final String message;

  const JobDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
