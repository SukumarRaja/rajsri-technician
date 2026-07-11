import 'package:equatable/equatable.dart';

abstract class JobActionEvent extends Equatable {
  const JobActionEvent();

  @override
  List<Object?> get props => [];
}

class AcceptJobEvent extends JobActionEvent {
  final int jobId;
  const AcceptJobEvent(this.jobId);
  @override
  List<Object?> get props => [jobId];
}

class RejectJobEvent extends JobActionEvent {
  final int jobId;
  final String? reason;
  const RejectJobEvent(this.jobId, {this.reason});
  @override
  List<Object?> get props => [jobId, reason];
}

class StartJobEvent extends JobActionEvent {
  final int jobId;
  const StartJobEvent(this.jobId);
  @override
  List<Object?> get props => [jobId];
}

class CompleteJobEvent extends JobActionEvent {
  final int jobId;
  final String? notes;
  const CompleteJobEvent(this.jobId, {this.notes});
  @override
  List<Object?> get props => [jobId, notes];
}
