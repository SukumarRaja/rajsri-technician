import 'package:json_annotation/json_annotation.dart';

part 'job_action_request.g.dart';

@JsonSerializable()
class JobActionRequest {
  @JsonKey(name: 'job_id')
  final int jobId;
  
  final String? notes; // Optional notes for complete/reject

  JobActionRequest({required this.jobId, this.notes});

  Map<String, dynamic> toJson() => _$JobActionRequestToJson(this);
}
