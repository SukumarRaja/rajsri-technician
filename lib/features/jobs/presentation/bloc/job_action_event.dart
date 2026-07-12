import 'package:equatable/equatable.dart';
import '../../data/models/complete_job_request.dart';

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
  final List<String>? images;
  final List<PartUsed>? partsUsed;

  const CompleteJobEvent(
    this.jobId, {
    this.notes,
    this.images,
    this.partsUsed,
  });

  @override
  List<Object?> get props => [jobId, notes, images, partsUsed];
}

class CancelJobEvent extends JobActionEvent {
  final int jobId;
  final String reason;

  const CancelJobEvent(this.jobId, this.reason);

  @override
  List<Object?> get props => [jobId, reason];
}
