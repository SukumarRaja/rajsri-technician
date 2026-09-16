import 'package:json_annotation/json_annotation.dart';

part 'dashboard_response.g.dart';

@JsonSerializable()
class DashboardResponse {
  final bool? success;
  final String? message;
  final DashboardData data;

  DashboardResponse({
    this.success,
    this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}

@JsonSerializable()
class DashboardData {
  final DashboardStats stats;
  @JsonKey(name: 'upcoming_jobs', defaultValue: [])
  final List<DashboardJob> upcomingJobs;
  @JsonKey(name: 'upcoming_amc_visits', defaultValue: [])
  final List<DashboardAmcVisit> upcomingAmcVisits;

  DashboardData({
    required this.stats,
    required this.upcomingJobs,
    required this.upcomingAmcVisits,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

@JsonSerializable()
class DashboardStats {
  @JsonKey(name: 'total_jobs', defaultValue: 0)
  final int totalJobs;
  @JsonKey(defaultValue: 0)
  final int pending;
  @JsonKey(name: 'in_progress', defaultValue: 0)
  final int inProgress;
  @JsonKey(defaultValue: 0)
  final int completed;
  @JsonKey(defaultValue: 0)
  final int cancelled;

  @JsonKey(name: 'total_amc', defaultValue: 0)
  final int totalAmc;
  @JsonKey(name: 'amc_pending', defaultValue: 0)
  final int amcPending;
  @JsonKey(name: 'amc_assigned', defaultValue: 0)
  final int amcAssigned;
  @JsonKey(name: 'amc_completed', defaultValue: 0)
  final int amcCompleted;
  @JsonKey(name: 'amc_missed', defaultValue: 0)
  final int amcMissed;

  DashboardStats({
    required this.totalJobs,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
    this.totalAmc = 0,
    this.amcPending = 0,
    this.amcAssigned = 0,
    this.amcCompleted = 0,
    this.amcMissed = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}

@JsonSerializable()
class DashboardJob {
  final int id;
  @JsonKey(name: 'booking_number')
  final String bookingNumber;
  @JsonKey(name: 'scheduled_date')
  final String? scheduledDate;
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
    this.scheduledDate,
    required this.time,
    required this.status,
    required this.statusLabel,
    required this.serviceName,
    required this.customerName,
    this.address,
  });

  factory DashboardJob.fromJson(Map<String, dynamic> json) =>
      _$DashboardJobFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardJobToJson(this);
}

@JsonSerializable()
class DashboardAmcVisit {
  final int id;
  @JsonKey(name: 'scheduled_date')
  final String? scheduledDate;
  @JsonKey(name: 'scheduled_time')
  final String? scheduledTime;
  final String status;
  @JsonKey(name: 'status_label')
  final String statusLabel;
  @JsonKey(name: 'plan_name')
  final String planName;
  @JsonKey(name: 'company_name')
  final String companyName;
  final String? address;

  DashboardAmcVisit({
    required this.id,
    this.scheduledDate,
    this.scheduledTime,
    required this.status,
    required this.statusLabel,
    required this.planName,
    required this.companyName,
    this.address,
  });

  factory DashboardAmcVisit.fromJson(Map<String, dynamic> json) =>
      _$DashboardAmcVisitFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardAmcVisitToJson(this);
}
