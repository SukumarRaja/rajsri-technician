// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_job_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteJobRequest _$CompleteJobRequestFromJson(Map<String, dynamic> json) =>
    CompleteJobRequest(
      afterNotes: json['after_notes'] as String?,
      notes: json['notes'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      partsUsed: (json['parts_used'] as List<dynamic>?)
          ?.map((e) => PartUsed.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentReceived: json['payment_received'] as bool?,
      paymentAmount: (json['payment_amount'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] as String?,
    );

Map<String, dynamic> _$CompleteJobRequestToJson(CompleteJobRequest instance) =>
    <String, dynamic>{
      'after_notes': instance.afterNotes,
      'notes': instance.notes,
      'images': instance.images,
      'parts_used': instance.partsUsed?.map((e) => e.toJson()).toList(),
      'payment_received': instance.paymentReceived,
      'payment_amount': instance.paymentAmount,
      'payment_method': instance.paymentMethod,
    };

PartUsed _$PartUsedFromJson(Map<String, dynamic> json) => PartUsed(
  productId: (json['product_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$PartUsedToJson(PartUsed instance) => <String, dynamic>{
  'product_id': instance.productId,
  'name': instance.name,
  'quantity': instance.quantity,
  'price': instance.price,
};
