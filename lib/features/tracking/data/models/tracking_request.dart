import 'package:json_annotation/json_annotation.dart';

part 'tracking_request.g.dart';

@JsonSerializable()
class TrackingRequest {
  final double latitude;
  final double longitude;

  TrackingRequest({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => _$TrackingRequestToJson(this);
}
