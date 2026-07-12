import 'package:equatable/equatable.dart';

abstract class ServiceHistoryEvent extends Equatable {
  const ServiceHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceHistoryEvent extends ServiceHistoryEvent {
  final String? search;
  final String? status;
  final int? page;
  final bool isRefresh;

  const FetchServiceHistoryEvent({
    this.search,
    this.status,
    this.page,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [search, status, page, isRefresh];
}
