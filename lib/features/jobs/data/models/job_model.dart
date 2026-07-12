import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class JobModel {
  final int id;
  @JsonKey(name: 'booking_number')
  final String? bookingNumber;
  final String? date;
  final String? time;
  final ServiceModel? service;
  final CustomerModel? customer;
  @JsonKey(name: 'scheduled_at')
  final String? scheduledAt;
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'cancelled_at')
  final String? cancelledAt;
  final String? address;
  final String? status;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  final dynamic price;
  @JsonKey(name: 'can_accept')
  final bool? canAccept;
  @JsonKey(name: 'can_start')
  final bool? canStart;
  @JsonKey(name: 'can_complete')
  final bool? canComplete;

  JobModel({
    required this.id,
    this.bookingNumber,
    this.date,
    this.time,
    this.service,
    this.customer,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.address,
    this.status,
    this.statusLabel,
    this.price,
    this.canAccept,
    this.canStart,
    this.canComplete,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobModelToJson(this);
}

@JsonSerializable()
class ServiceModel {
  final int id;
  final String? name;
  final String? image;

  ServiceModel({
    required this.id,
    this.name,
    this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}

@JsonSerializable()
class CustomerModel {
  final int id;
  final String? name;
  final String? mobile;

  CustomerModel({
    required this.id,
    this.name,
    this.mobile,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}
