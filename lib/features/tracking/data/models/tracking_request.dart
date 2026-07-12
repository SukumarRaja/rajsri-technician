import 'package:json_annotation/json_annotation.dart';

part 'tracking_request.g.dart';

@JsonSerializable()
class TrackingRequest {
  final double lat;
  final double lng;
  @JsonKey(name: 'recorded_at')
  final DateTime recordedAt;

  TrackingRequest({
    required this.lat,
    required this.lng,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() => _$TrackingRequestToJson(this);
}
