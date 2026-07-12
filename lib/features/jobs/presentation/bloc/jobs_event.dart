import 'package:equatable/equatable.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object?> get props => [];
}

class FetchJobsEvent extends JobsEvent {
  final String? search;
  final String? status;
  final int? todayPage;
  final int? upcomingPage;
  final bool isRefresh;

  const FetchJobsEvent({
    this.search,
    this.status,
    this.todayPage,
    this.upcomingPage,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [search, status, todayPage, upcomingPage, isRefresh];
}
