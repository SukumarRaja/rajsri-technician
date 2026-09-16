import 'package:json_annotation/json_annotation.dart';

part 'complete_job_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CompleteJobRequest {
  @JsonKey(name: 'after_notes')
  final String? afterNotes;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'images')
  final List<String>? images;

  @JsonKey(name: 'parts_used')
  final List<PartUsed>? partsUsed;

  @JsonKey(name: 'payment_received')
  final bool? paymentReceived;

  @JsonKey(name: 'payment_amount')
  final double? paymentAmount;

  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  CompleteJobRequest({
    this.afterNotes,
    this.notes,
    this.images,
    this.partsUsed,
    this.paymentReceived,
    this.paymentAmount,
    this.paymentMethod,
  });

  factory CompleteJobRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteJobRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteJobRequestToJson(this);
}

@JsonSerializable()
class PartUsed {
  @JsonKey(name: 'product_id')
  final int? productId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'price')
  final double price;

  PartUsed({
    this.productId,
    this.name,
    required this.quantity,
    required this.price,
  });

  factory PartUsed.fromJson(Map<String, dynamic> json) => _$PartUsedFromJson(json);

  Map<String, dynamic> toJson() => _$PartUsedToJson(this);
}
