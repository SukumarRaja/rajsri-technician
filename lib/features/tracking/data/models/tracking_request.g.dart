// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingRequest _$TrackingRequestFromJson(Map<String, dynamic> json) =>
    TrackingRequest(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );

Map<String, dynamic> _$TrackingRequestToJson(TrackingRequest instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'recorded_at': instance.recordedAt.toIso8601String(),
    };
