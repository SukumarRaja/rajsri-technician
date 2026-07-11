// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingRequest _$TrackingRequestFromJson(Map<String, dynamic> json) =>
    TrackingRequest(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$TrackingRequestToJson(TrackingRequest instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
