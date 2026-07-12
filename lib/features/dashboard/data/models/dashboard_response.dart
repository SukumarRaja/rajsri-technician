import 'package:json_annotation/json_annotation.dart';

part 'dashboard_response.g.dart';

@JsonSerializable()
class DashboardResponse {
  final DashboardData data;

  DashboardResponse({required this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => _$DashboardResponseFromJson(json);
}

@JsonSerializable()
class DashboardData {
  final DashboardStats stats;
  @JsonKey(name: 'upcoming_jobs')
  final List<DashboardJob> upcomingJobs;

  DashboardData({required this.stats, required this.upcomingJobs});

  factory DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);
}

@JsonSerializable()
class DashboardStats {
  @JsonKey(name: 'total_jobs')
  final int totalJobs;
  final int pending;
  @JsonKey(name: 'in_progress')
  final int inProgress;
  final int completed;
  final int cancelled;

  DashboardStats({
    required this.totalJobs,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@JsonSerializable()
class DashboardJob {
  final int id;
  @JsonKey(name: 'booking_number')
  final String bookingNumber;
  final String time;
  final String status;
  @JsonKey(name: 'status_label')
  final String statusLabel;
  @JsonKey(name: 'service_name')
  final String serviceName;
  @JsonKey(name: 'customer_name')
  final String customerName;
  final String? address;

  DashboardJob({
    required this.id,
    required this.bookingNumber,
    required this.time,
    required this.status,
    required this.statusLabel,
    required this.serviceName,
    required this.customerName,
    this.address,
  });

  factory DashboardJob.fromJson(Map<String, dynamic> json) => _$DashboardJobFromJson(json);
}
