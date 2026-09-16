import 'package:json_annotation/json_annotation.dart';

part 'update_services_request.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateServicesRequest {
  final List<UpdateServiceItem> services;

  UpdateServicesRequest({required this.services});

  factory UpdateServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateServicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateServicesRequestToJson(this);
}

@JsonSerializable()
class UpdateServiceItem {
  @JsonKey(name: 'service_id')
  final int serviceId;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final double unitPrice;

  UpdateServiceItem({
    required this.serviceId,
    required this.quantity,
    required this.unitPrice,
  });

  factory UpdateServiceItem.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateServiceItemToJson(this);
}
