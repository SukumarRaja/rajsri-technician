// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
  id: (json['id'] as num).toInt(),
  bookingNumber: json['booking_number'] as String?,
  date: json['date'] as String?,
  time: json['time'] as String?,
  service: json['service'] == null
      ? null
      : ServiceModel.fromJson(json['service'] as Map<String, dynamic>),
  customer: json['customer'] == null
      ? null
      : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
  scheduledAt: json['scheduled_at'] as String?,
  startedAt: json['started_at'] as String?,
  completedAt: json['completed_at'] as String?,
  cancelledAt: json['cancelled_at'] as String?,
  address: json['address'] as String?,
  status: json['status'] as String?,
  statusLabel: json['status_label'] as String?,
  price: json['price'],
  canAccept: json['can_accept'] as bool?,
  canStart: json['can_start'] as bool?,
  canComplete: json['can_complete'] as bool?,
);

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
  'id': instance.id,
  'booking_number': instance.bookingNumber,
  'date': instance.date,
  'time': instance.time,
  'service': instance.service,
  'customer': instance.customer,
  'scheduled_at': instance.scheduledAt,
  'started_at': instance.startedAt,
  'completed_at': instance.completedAt,
  'cancelled_at': instance.cancelledAt,
  'address': instance.address,
  'status': instance.status,
  'status_label': instance.statusLabel,
  'price': instance.price,
  'can_accept': instance.canAccept,
  'can_start': instance.canStart,
  'can_complete': instance.canComplete,
};

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobile': instance.mobile,
    };
