// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_job_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteJobRequest _$CompleteJobRequestFromJson(Map<String, dynamic> json) =>
    CompleteJobRequest(
      notes: json['notes'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      partsUsed: (json['parts_used'] as List<dynamic>?)
          ?.map((e) => PartUsed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompleteJobRequestToJson(CompleteJobRequest instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'images': instance.images,
      'parts_used': instance.partsUsed?.map((e) => e.toJson()).toList(),
    };

PartUsed _$PartUsedFromJson(Map<String, dynamic> json) => PartUsed(
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$PartUsedToJson(PartUsed instance) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
  'price': instance.price,
};
