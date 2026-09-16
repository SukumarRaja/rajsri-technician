import 'package:json_annotation/json_annotation.dart';

part 'job_detail_response.g.dart';

@JsonSerializable()
class JobDetailResponse {
  final bool success;
  final String message;
  final JobDetailModel data;

  JobDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JobDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$JobDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailResponseToJson(this);
}

@JsonSerializable()
class JobDetailModel {
  final int id;
  @JsonKey(name: 'booking_number')
  final String? bookingNumber;
  final JobDetailService? service;
  final JobDetailCustomer? customer;
  @JsonKey(name: 'scheduled_at')
  final String? scheduledAt;
  final String? address;
  final String? notes;
  @JsonKey(name: 'before_notes')
  final String? beforeNotes;
  @JsonKey(name: 'after_notes')
  final String? afterNotes;
  final String? status;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  final dynamic price;
  @JsonKey(name: 'total_price')
  final dynamic totalPrice;
  @JsonKey(name: 'accepted_at')
  final String? acceptedAt;
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'can_accept')
  final bool? canAccept;
  @JsonKey(name: 'can_start')
  final bool? canStart;
  @JsonKey(name: 'can_complete')
  final bool? canComplete;
  @JsonKey(defaultValue: [])
  final List<JobDetailItemService> services;
  @JsonKey(defaultValue: [])
  final List<dynamic> logs;

  JobDetailModel({
    required this.id,
    this.bookingNumber,
    this.service,
    this.customer,
    this.scheduledAt,
    this.address,
    this.notes,
    this.beforeNotes,
    this.afterNotes,
    this.status,
    this.statusLabel,
    this.price,
    this.totalPrice,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.canAccept,
    this.canStart,
    this.canComplete,
    required this.services,
    required this.logs,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) =>
      _$JobDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailModelToJson(this);
}

@JsonSerializable()
class JobDetailService {
  final int id;
  final String? name;
  final String? image;
  final String? description;
  final String? duration;

  JobDetailService({
    required this.id,
    this.name,
    this.image,
    this.description,
    this.duration,
  });

  factory JobDetailService.fromJson(Map<String, dynamic> json) =>
      _$JobDetailServiceFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailServiceToJson(this);
}

@JsonSerializable()
class JobDetailCustomer {
  final int id;
  final String? name;
  final String? mobile;
  final String? email;

  JobDetailCustomer({
    required this.id,
    this.name,
    this.mobile,
    this.email,
  });

  factory JobDetailCustomer.fromJson(Map<String, dynamic> json) =>
      _$JobDetailCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailCustomerToJson(this);
}

@JsonSerializable()
class JobDetailItemService {
  final int id;
  final String? name;
  final int? quantity;
  @JsonKey(name: 'unit_price')
  final dynamic unitPrice;
  @JsonKey(name: 'total_price')
  final dynamic totalPrice;

  JobDetailItemService({
    required this.id,
    this.name,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  factory JobDetailItemService.fromJson(Map<String, dynamic> json) =>
      _$JobDetailItemServiceFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailItemServiceToJson(this);
}
