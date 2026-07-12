// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobsResponse _$JobsResponseFromJson(Map<String, dynamic> json) => JobsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: JobsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$JobsResponseToJson(JobsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

JobsData _$JobsDataFromJson(Map<String, dynamic> json) => JobsData(
  today: PaginatedJobs.fromJson(json['today'] as Map<String, dynamic>),
  upcoming: PaginatedJobs.fromJson(json['upcoming'] as Map<String, dynamic>),
);

Map<String, dynamic> _$JobsDataToJson(JobsData instance) => <String, dynamic>{
  'today': instance.today,
  'upcoming': instance.upcoming,
};

PaginatedJobs _$PaginatedJobsFromJson(Map<String, dynamic> json) =>
    PaginatedJobs(
      data: (json['data'] as List<dynamic>)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PaginatedJobsToJson(PaginatedJobs instance) =>
    <String, dynamic>{'data': instance.data, 'pagination': instance.pagination};

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

HistoryResponse _$HistoryResponseFromJson(Map<String, dynamic> json) =>
    HistoryResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PaginatedJobs.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HistoryResponseToJson(HistoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
