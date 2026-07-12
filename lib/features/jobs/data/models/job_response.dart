import 'package:json_annotation/json_annotation.dart';
import 'job_model.dart';

part 'job_response.g.dart';

@JsonSerializable()
class JobsResponse {
  final bool success;
  final String message;
  final JobsData data;

  JobsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) => _$JobsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobsResponseToJson(this);
}

@JsonSerializable()
class JobsData {
  final PaginatedJobs today;
  final PaginatedJobs upcoming;

  JobsData({
    required this.today,
    required this.upcoming,
  });

  factory JobsData.fromJson(Map<String, dynamic> json) => _$JobsDataFromJson(json);
  Map<String, dynamic> toJson() => _$JobsDataToJson(this);
}

@JsonSerializable()
class PaginatedJobs {
  final List<JobModel> data;
  final PaginationModel pagination;

  PaginatedJobs({
    required this.data,
    required this.pagination,
  });

  factory PaginatedJobs.fromJson(Map<String, dynamic> json) => _$PaginatedJobsFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedJobsToJson(this);
}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}

@JsonSerializable()
class HistoryResponse {
  final bool success;
  final String message;
  final PaginatedJobs data;

  HistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) => _$HistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryResponseToJson(this);
}
