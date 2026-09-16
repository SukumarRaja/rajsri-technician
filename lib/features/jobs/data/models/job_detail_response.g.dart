// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDetailResponse _$JobDetailResponseFromJson(Map<String, dynamic> json) =>
    JobDetailResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: JobDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobDetailResponseToJson(JobDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

JobDetailModel _$JobDetailModelFromJson(
  Map<String, dynamic> json,
) => JobDetailModel(
  id: (json['id'] as num).toInt(),
  bookingNumber: json['booking_number'] as String?,
  service: json['service'] == null
      ? null
      : JobDetailService.fromJson(json['service'] as Map<String, dynamic>),
  customer: json['customer'] == null
      ? null
      : JobDetailCustomer.fromJson(json['customer'] as Map<String, dynamic>),
  scheduledAt: json['scheduled_at'] as String?,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  beforeNotes: json['before_notes'] as String?,
  afterNotes: json['after_notes'] as String?,
  status: json['status'] as String?,
  statusLabel: json['status_label'] as String?,
  price: json['price'],
  totalPrice: json['total_price'],
  acceptedAt: json['accepted_at'] as String?,
  startedAt: json['started_at'] as String?,
  completedAt: json['completed_at'] as String?,
  canAccept: json['can_accept'] as bool?,
  canStart: json['can_start'] as bool?,
  canComplete: json['can_complete'] as bool?,
  services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => JobDetailItemService.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  logs: json['logs'] as List<dynamic>? ?? [],
);

Map<String, dynamic> _$JobDetailModelToJson(JobDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_number': instance.bookingNumber,
      'service': instance.service,
      'customer': instance.customer,
      'scheduled_at': instance.scheduledAt,
      'address': instance.address,
      'notes': instance.notes,
      'before_notes': instance.beforeNotes,
      'after_notes': instance.afterNotes,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'price': instance.price,
      'total_price': instance.totalPrice,
      'accepted_at': instance.acceptedAt,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'can_accept': instance.canAccept,
      'can_start': instance.canStart,
      'can_complete': instance.canComplete,
      'services': instance.services,
      'logs': instance.logs,
    };

JobDetailService _$JobDetailServiceFromJson(Map<String, dynamic> json) =>
    JobDetailService(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$JobDetailServiceToJson(JobDetailService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'duration': instance.duration,
    };

JobDetailCustomer _$JobDetailCustomerFromJson(Map<String, dynamic> json) =>
    JobDetailCustomer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$JobDetailCustomerToJson(JobDetailCustomer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
    };

JobDetailItemService _$JobDetailItemServiceFromJson(
  Map<String, dynamic> json,
) => JobDetailItemService(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  unitPrice: json['unit_price'],
  totalPrice: json['total_price'],
);

Map<String, dynamic> _$JobDetailItemServiceToJson(
  JobDetailItemService instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
  'total_price': instance.totalPrice,
};
