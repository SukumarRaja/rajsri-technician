import 'package:equatable/equatable.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();
  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingActive extends TrackingState {
  final double? latitude;
  final double? longitude;
  final double? speed;
  final DateTime lastSync;

  const TrackingActive({this.latitude, this.longitude, this.speed, required this.lastSync});
  
  @override
  List<Object?> get props => [latitude, longitude, speed, lastSync];
}

class TrackingError extends TrackingState {
  final String message;
  const TrackingError(this.message);
  @override
  List<Object?> get props => [message];
}

class TrackingInactive extends TrackingState {}
