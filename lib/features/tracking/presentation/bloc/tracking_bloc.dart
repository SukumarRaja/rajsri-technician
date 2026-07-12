import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/location_service.dart';
import '../../domain/repositories/tracking_repository.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository repository;
  final LocationService locationService;
  final SharedPreferences sharedPreferences;
  StreamSubscription<LocationData>? _locationSubscription;

  LocationData? _latestLocation;

  static const String _trackingKey = 'IS_TRACKING_ACTIVE';

  TrackingBloc({
    required this.repository,
    required this.locationService,
    required this.sharedPreferences,
  }) : super(TrackingInitial()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<LocationUpdatedEvent>(_onLocationUpdated);

    _initializeTracking();
  }

  void _initializeTracking() {
    final isTracking = sharedPreferences.getBool(_trackingKey) ?? false;
    if (isTracking) {
      add(StartTrackingEvent());
    }
  }

  Future<void> _onStartTracking(
    StartTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    final hasPermission = await locationService.checkAndRequestPermissions();
    if (!hasPermission) {
      emit(
        const TrackingError(
          'Location permissions not granted. Cannot start tracking.',
        ),
      );
      return;
    }

    await sharedPreferences.setBool(_trackingKey, true);

    _locationSubscription?.cancel();
    _locationSubscription = locationService.getLocationStream().listen((
      locationData,
    ) {
      add(
        LocationUpdatedEvent(
          locationData.latitude ?? 0.0,
          locationData.longitude ?? 0.0,
          speed: locationData.speed,
        ),
      );
    });

    FlutterBackgroundService().startService();

    emit(TrackingActive(lastSync: DateTime.now()));
  }

  Future<void> _onStopTracking(
    StopTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await sharedPreferences.setBool(_trackingKey, false);
    _locationSubscription?.cancel();
    FlutterBackgroundService().invoke("stopService");
    emit(TrackingInactive());
  }

  void _onLocationUpdated(
    LocationUpdatedEvent event,
    Emitter<TrackingState> emit,
  ) {
    _latestLocation = LocationData.fromMap({
      'latitude': event.latitude,
      'longitude': event.longitude,
      'speed': event.speed,
    });

    emit(
      TrackingActive(
        latitude: event.latitude,
        longitude: event.longitude,
        speed: event.speed,
        lastSync: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
