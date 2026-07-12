// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{'data': instance.data};

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      upcomingJobs: (json['upcoming_jobs'] as List<dynamic>)
          .map((e) => DashboardJob.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'upcoming_jobs': instance.upcomingJobs,
    };

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalJobs: (json['total_jobs'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      inProgress: (json['in_progress'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      cancelled: (json['cancelled'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'total_jobs': instance.totalJobs,
      'pending': instance.pending,
      'in_progress': instance.inProgress,
      'completed': instance.completed,
      'cancelled': instance.cancelled,
    };

DashboardJob _$DashboardJobFromJson(Map<String, dynamic> json) => DashboardJob(
  id: (json['id'] as num).toInt(),
  bookingNumber: json['booking_number'] as String,
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
      'time': instance.time,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'service_name': instance.serviceName,
      'customer_name': instance.customerName,
      'address': instance.address,
    };
