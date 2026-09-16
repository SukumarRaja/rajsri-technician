// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_services_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateServicesRequest _$UpdateServicesRequestFromJson(
  Map<String, dynamic> json,
) => UpdateServicesRequest(
  services: (json['services'] as List<dynamic>)
      .map((e) => UpdateServiceItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateServicesRequestToJson(
  UpdateServicesRequest instance,
) => <String, dynamic>{
  'services': instance.services.map((e) => e.toJson()).toList(),
};

UpdateServiceItem _$UpdateServiceItemFromJson(Map<String, dynamic> json) =>
    UpdateServiceItem(
      serviceId: (json['service_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
    );

Map<String, dynamic> _$UpdateServiceItemToJson(UpdateServiceItem instance) =>
    <String, dynamic>{
      'service_id': instance.serviceId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
    };
