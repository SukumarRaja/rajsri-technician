// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobActionRequest _$JobActionRequestFromJson(Map<String, dynamic> json) =>
    JobActionRequest(
      jobId: (json['job_id'] as num).toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$JobActionRequestToJson(JobActionRequest instance) =>
    <String, dynamic>{'job_id': instance.jobId, 'notes': instance.notes};
