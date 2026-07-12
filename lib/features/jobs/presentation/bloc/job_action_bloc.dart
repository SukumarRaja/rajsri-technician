import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/jobs_repository.dart';
import 'job_action_event.dart';
import 'job_action_state.dart';

class JobActionBloc extends Bloc<JobActionEvent, JobActionState> {
  final JobsRepository repository;

  JobActionBloc({required this.repository}) : super(JobActionInitial()) {
    on<AcceptJobEvent>(_onAcceptJob);
    on<RejectJobEvent>(_onRejectJob);
    on<StartJobEvent>(_onStartJob);
    on<CompleteJobEvent>(_onCompleteJob);
    on<CancelJobEvent>(_onCancelJob);
  }

  Future<void> _onAcceptJob(AcceptJobEvent event, Emitter<JobActionState> emit) async {
    emit(JobActionLoading(event.jobId));
    final result = await repository.acceptJob(event.jobId);
    result.fold(
      (failure) => emit(JobActionFailure(failure.message)),
      (_) => emit(JobActionSuccess(event.jobId, 'Job accepted successfully')),
    );
  }

  Future<void> _onRejectJob(RejectJobEvent event, Emitter<JobActionState> emit) async {
    emit(JobActionLoading(event.jobId));
    final result = await repository.rejectJob(event.jobId, reason: event.reason);
    result.fold(
      (failure) => emit(JobActionFailure(failure.message)),
      (_) => emit(JobActionSuccess(event.jobId, 'Job rejected')),
    );
  }

  Future<void> _onStartJob(StartJobEvent event, Emitter<JobActionState> emit) async {
    emit(JobActionLoading(event.jobId));
    final result = await repository.startJob(event.jobId);
    result.fold(
      (failure) => emit(JobActionFailure(failure.message)),
      (_) => emit(JobActionSuccess(event.jobId, 'Job started')),
    );
  }

  Future<void> _onCompleteJob(CompleteJobEvent event, Emitter<JobActionState> emit) async {
    emit(JobActionLoading(event.jobId));
    final result = await repository.completeJob(
      event.jobId,
      notes: event.notes,
      images: event.images,
      partsUsed: event.partsUsed,
    );
    result.fold(
      (failure) => emit(JobActionFailure(failure.message)),
      (_) => emit(JobActionSuccess(event.jobId, 'Job completed successfully')),
    );
  }

  Future<void> _onCancelJob(CancelJobEvent event, Emitter<JobActionState> emit) async {
    emit(JobActionLoading(event.jobId));
    final result = await repository.cancelJob(event.jobId, event.reason);
    result.fold(
      (failure) => emit(JobActionFailure(failure.message)),
      (_) => emit(JobActionSuccess(event.jobId, 'Job cancelled successfully')),
    );
  }
}
