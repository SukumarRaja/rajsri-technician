import 'package:equatable/equatable.dart';
import '../../../jobs/data/models/job_response.dart';
import '../../../jobs/data/models/job_model.dart';

abstract class ServiceHistoryState extends Equatable {
  const ServiceHistoryState();

  @override
  List<Object?> get props => [];
}

class ServiceHistoryInitial extends ServiceHistoryState {}

class ServiceHistoryLoading extends ServiceHistoryState {}

class ServiceHistoryLoaded extends ServiceHistoryState {
  final List<JobModel> jobs;
  final PaginationModel pagination;
  final String? search;
  final String? status;
  final bool isFetchingMore;
  final bool hasReachedMax;

  const ServiceHistoryLoaded({
    required this.jobs,
    required this.pagination,
    this.search,
    this.status,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  ServiceHistoryLoaded copyWith({
    List<JobModel>? jobs,
    PaginationModel? pagination,
    String? search,
    String? status,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return ServiceHistoryLoaded(
      jobs: jobs ?? this.jobs,
      pagination: pagination ?? this.pagination,
      search: search ?? this.search,
      status: status ?? this.status,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        jobs,
        pagination,
        search,
        status,
        isFetchingMore,
        hasReachedMax,
      ];
}

class ServiceHistoryError extends ServiceHistoryState {
  final String message;

  const ServiceHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
