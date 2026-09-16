import 'package:equatable/equatable.dart';

abstract class JobDetailEvent extends Equatable {
  const JobDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchJobDetailEvent extends JobDetailEvent {
  final int jobId;

  const FetchJobDetailEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
