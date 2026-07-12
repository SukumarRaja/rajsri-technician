import 'package:flutter_bloc/flutter_bloc.dart';
import 'jobs_event.dart';
import 'jobs_state.dart';
import '../../data/models/job_response.dart';
import '../../domain/repositories/jobs_repository.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final JobsRepository repository;

  JobsBloc({required this.repository}) : super(JobsInitial()) {
    on<FetchJobsEvent>(_onFetchJobs);
  }

  Future<void> _onFetchJobs(FetchJobsEvent event, Emitter<JobsState> emit) async {
    final currentState = state;
    bool isPagination = event.todayPage != null || event.upcomingPage != null;

    if (event.isRefresh || currentState is! JobsLoaded) {
      emit(JobsLoading());
    } else if (isPagination) {
      emit(currentState.copyWith(isFetchingMore: true));
    }

    final search = event.search ?? (currentState is JobsLoaded ? currentState.search : null);
    final status = event.status ?? (currentState is JobsLoaded ? currentState.status : null);
    
    int todayPage = event.todayPage ?? 1;
    int upcomingPage = event.upcomingPage ?? 1;

    final result = await repository.getJobs(
      search: search,
      status: status,
      todayPage: todayPage,
      upcomingPage: upcomingPage,
    );

    result.fold(
      (failure) {
        if (currentState is JobsLoaded) {
          emit(currentState.copyWith(isFetchingMore: false));
        } else {
          emit(JobsError(message: failure.message));
        }
      },
      (data) {
        if (isPagination && currentState is JobsLoaded && !event.isRefresh) {
          final newTodayData = event.todayPage != null 
              ? [...currentState.jobsData.today.data, ...data.today.data]
              : currentState.jobsData.today.data;
              
          final newUpcomingData = event.upcomingPage != null
              ? [...currentState.jobsData.upcoming.data, ...data.upcoming.data]
              : currentState.jobsData.upcoming.data;

          final updatedData = JobsData(
            today: PaginatedJobs(
              data: newTodayData,
              pagination: event.todayPage != null ? data.today.pagination : currentState.jobsData.today.pagination,
            ),
            upcoming: PaginatedJobs(
              data: newUpcomingData,
              pagination: event.upcomingPage != null ? data.upcoming.pagination : currentState.jobsData.upcoming.pagination,
            ),
          );

          emit(JobsLoaded(
            jobsData: updatedData,
            search: search,
            status: status,
            hasReachedMaxToday: updatedData.today.pagination.currentPage >= updatedData.today.pagination.lastPage,
            hasReachedMaxUpcoming: updatedData.upcoming.pagination.currentPage >= updatedData.upcoming.pagination.lastPage,
            isFetchingMore: false,
          ));
        } else {
          emit(JobsLoaded(
            jobsData: data,
            search: search,
            status: status,
            hasReachedMaxToday: data.today.pagination.currentPage >= data.today.pagination.lastPage,
            hasReachedMaxUpcoming: data.upcoming.pagination.currentPage >= data.upcoming.pagination.lastPage,
            isFetchingMore: false,
          ));
        }
      },
    );
  }
}
