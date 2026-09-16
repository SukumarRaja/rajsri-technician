import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/jobs_repository.dart';
import 'job_detail_event.dart';
import 'job_detail_state.dart';

class JobDetailBloc extends Bloc<JobDetailEvent, JobDetailState> {
  final JobsRepository repository;

  JobDetailBloc({required this.repository}) : super(JobDetailInitial()) {
    on<FetchJobDetailEvent>(_onFetchJobDetail);
  }

  Future<void> _onFetchJobDetail(
    FetchJobDetailEvent event,
    Emitter<JobDetailState> emit,
  ) async {
    emit(JobDetailLoading());
    try {
      final response = await repository.getJobDetail(event.jobId);
      response.fold(
        (failure) => emit(JobDetailError(failure.message)),
        (jobDetail) => emit(JobDetailLoaded(jobDetail)),
      );
    } catch (e) {
      emit(JobDetailError(e.toString()));
    }
  }
}
