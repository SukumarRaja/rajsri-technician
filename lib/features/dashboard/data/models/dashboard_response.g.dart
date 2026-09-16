// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      upcomingJobs:
          (json['upcoming_jobs'] as List<dynamic>?)
              ?.map((e) => DashboardJob.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      upcomingAmcVisits:
          (json['upcoming_amc_visits'] as List<dynamic>?)
              ?.map(
                (e) => DashboardAmcVisit.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'upcoming_jobs': instance.upcomingJobs,
      'upcoming_amc_visits': instance.upcomingAmcVisits,
    };

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalJobs: (json['total_jobs'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      inProgress: (json['in_progress'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
      totalAmc: (json['total_amc'] as num?)?.toInt() ?? 0,
      amcPending: (json['amc_pending'] as num?)?.toInt() ?? 0,
      amcAssigned: (json['amc_assigned'] as num?)?.toInt() ?? 0,
      amcCompleted: (json['amc_completed'] as num?)?.toInt() ?? 0,
      amcMissed: (json['amc_missed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'total_jobs': instance.totalJobs,
      'pending': instance.pending,
      'in_progress': instance.inProgress,
      'completed': instance.completed,
      'cancelled': instance.cancelled,
      'total_amc': instance.totalAmc,
      'amc_pending': instance.amcPending,
      'amc_assigned': instance.amcAssigned,
      'amc_completed': instance.amcCompleted,
      'amc_missed': instance.amcMissed,
    };

DashboardJob _$DashboardJobFromJson(Map<String, dynamic> json) => DashboardJob(
  id: (json['id'] as num).toInt(),
  bookingNumber: json['booking_number'] as String,
  scheduledDate: json['scheduled_date'] as String?,
  time: json['time'] as String,
  status: json['status'] as String,
  statusLabel: json['status_label'] as String,
  serviceName: json['service_name'] as String,
  customerName: json['customer_name'] as String,
  address: json['address'] as String?,
);

Map<String, dynamic> _$DashboardJobToJson(DashboardJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_number': instance.bookingNumber,
      'scheduled_date': instance.scheduledDate,
      'time': instance.time,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'service_name': instance.serviceName,
      'customer_name': instance.customerName,
      'address': instance.address,
    };

DashboardAmcVisit _$DashboardAmcVisitFromJson(Map<String, dynamic> json) =>
    DashboardAmcVisit(
      id: (json['id'] as num).toInt(),
      scheduledDate: json['scheduled_date'] as String?,
      scheduledTime: json['scheduled_time'] as String?,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      planName: json['plan_name'] as String,
      companyName: json['company_name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$DashboardAmcVisitToJson(DashboardAmcVisit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduled_date': instance.scheduledDate,
      'scheduled_time': instance.scheduledTime,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'plan_name': instance.planName,
      'company_name': instance.companyName,
      'address': instance.address,
    };
