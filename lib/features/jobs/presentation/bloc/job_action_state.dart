import 'package:equatable/equatable.dart';

abstract class JobActionState extends Equatable {
  const JobActionState();
  
  @override
  List<Object?> get props => [];
}

class JobActionInitial extends JobActionState {}

class JobActionLoading extends JobActionState {
  final int jobId;
  const JobActionLoading(this.jobId);
  @override
  List<Object?> get props => [jobId];
}

class JobActionSuccess extends JobActionState {
  final int jobId;
  final String message;
  const JobActionSuccess(this.jobId, this.message);
  @override
  List<Object?> get props => [jobId, message];
}

class JobActionFailure extends JobActionState {
  final String message;
  const JobActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
