import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_history_event.dart';
import 'service_history_state.dart';
import '../../../jobs/domain/repositories/jobs_repository.dart';

class ServiceHistoryBloc extends Bloc<ServiceHistoryEvent, ServiceHistoryState> {
  final JobsRepository repository;

  ServiceHistoryBloc({required this.repository}) : super(ServiceHistoryInitial()) {
    on<FetchServiceHistoryEvent>(_onFetchServiceHistory);
  }

  Future<void> _onFetchServiceHistory(
    FetchServiceHistoryEvent event,
    Emitter<ServiceHistoryState> emit,
  ) async {
    final currentState = state;
    bool isFetchingMore = event.page != null && event.page! > 1;

    if (event.isRefresh || currentState is! ServiceHistoryLoaded) {
      emit(ServiceHistoryLoading());
    } else if (isFetchingMore) {
      emit(currentState.copyWith(isFetchingMore: true));
    }

    final result = await repository.getHistory(
      search: event.search,
      status: event.status,
      page: event.page ?? 1,
    );

    result.fold(
      (failure) {
        emit(ServiceHistoryError(message: failure.message));
      },
      (data) {
        if (isFetchingMore && currentState is ServiceHistoryLoaded) {
          final updatedJobs = List.of(currentState.jobs)..addAll(data.data);
          emit(ServiceHistoryLoaded(
            jobs: updatedJobs,
            pagination: data.pagination,
            search: event.search,
            status: event.status,
            isFetchingMore: false,
            hasReachedMax: data.pagination.currentPage >= data.pagination.lastPage,
          ));
        } else {
          emit(ServiceHistoryLoaded(
            jobs: data.data,
            pagination: data.pagination,
            search: event.search,
            status: event.status,
            isFetchingMore: false,
            hasReachedMax: data.pagination.currentPage >= data.pagination.lastPage,
          ));
        }
      },
    );
  }
}
