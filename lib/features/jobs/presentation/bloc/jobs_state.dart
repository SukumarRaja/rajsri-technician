import 'package:equatable/equatable.dart';
import '../../data/models/job_response.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object?> get props => [];
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final JobsData jobsData;
  final String? search;
  final String? status;
  final bool hasReachedMaxToday;
  final bool hasReachedMaxUpcoming;
  final bool isFetchingMore;

  const JobsLoaded({
    required this.jobsData,
    this.search,
    this.status,
    this.hasReachedMaxToday = false,
    this.hasReachedMaxUpcoming = false,
    this.isFetchingMore = false,
  });

  JobsLoaded copyWith({
    JobsData? jobsData,
    String? search,
    String? status,
    bool? hasReachedMaxToday,
    bool? hasReachedMaxUpcoming,
    bool? isFetchingMore,
  }) {
    return JobsLoaded(
      jobsData: jobsData ?? this.jobsData,
      search: search ?? this.search,
      status: status ?? this.status,
      hasReachedMaxToday: hasReachedMaxToday ?? this.hasReachedMaxToday,
      hasReachedMaxUpcoming: hasReachedMaxUpcoming ?? this.hasReachedMaxUpcoming,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        jobsData,
        search,
        status,
        hasReachedMaxToday,
        hasReachedMaxUpcoming,
        isFetchingMore,
      ];
}

class JobsError extends JobsState {
  final String message;

  const JobsError({required this.message});

  @override
  List<Object?> get props => [message];
}
