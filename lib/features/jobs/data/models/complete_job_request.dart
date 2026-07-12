import 'package:json_annotation/json_annotation.dart';

part 'complete_job_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CompleteJobRequest {
  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'images')
  final List<String>? images;

  @JsonKey(name: 'parts_used')
  final List<PartUsed>? partsUsed;

  CompleteJobRequest({
    this.notes,
    this.images,
    this.partsUsed,
  });

  factory CompleteJobRequest.fromJson(Map<String, dynamic> json) => _$CompleteJobRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteJobRequestToJson(this);
}

@JsonSerializable()
class PartUsed {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'price')
  final double price;

  PartUsed({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory PartUsed.fromJson(Map<String, dynamic> json) => _$PartUsedFromJson(json);

  Map<String, dynamic> toJson() => _$PartUsedToJson(this);
}
