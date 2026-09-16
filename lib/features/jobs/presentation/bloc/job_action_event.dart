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
  final String? afterNotes;
  final String? notes;
  final List<String>? images;
  final List<PartUsed>? partsUsed;
  final bool? paymentReceived;
  final double? paymentAmount;
  final String? paymentMethod;

  const CompleteJobEvent(
    this.jobId, {
    this.afterNotes,
    this.notes,
    this.images,
    this.partsUsed,
    this.paymentReceived,
    this.paymentAmount,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        jobId,
        afterNotes,
        notes,
        images,
        partsUsed,
        paymentReceived,
        paymentAmount,
        paymentMethod,
      ];
}

class CancelJobEvent extends JobActionEvent {
  final int jobId;
  final String reason;

  const CancelJobEvent(this.jobId, this.reason);

  @override
  List<Object?> get props => [jobId, reason];
}
