import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();
  @override
  List<Object> get props => [];
}

class StartTrackingEvent extends TrackingEvent {}

class StopTrackingEvent extends TrackingEvent {}

class LocationUpdatedEvent extends TrackingEvent {
  final double latitude;
  final double longitude;
  final double? speed;
  const LocationUpdatedEvent(this.latitude, this.longitude, {this.speed});
  
  @override
  List<Object> get props => [latitude, longitude];
}
