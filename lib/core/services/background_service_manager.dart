import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/injection_container.dart' as di;
import '../constants/app_constants.dart';
import '../../features/tracking/domain/repositories/tracking_repository.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'technician_tracking', // id
    'Location Tracking', // name
    description: 'This channel is used for background location tracking.',
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'technician_tracking',
      initialNotificationTitle: 'Technician Tracking',
      initialNotificationContent: 'Tracking location in background',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Setup local notifications for foreground service updates (Android)
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize dependency injection for the isolate
  await di.init();

  final trackingRepo = di.sl<TrackingRepository>();
  final prefs = di.sl<SharedPreferences>();

  Position? latestLocation;

  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  final locationSubscription =
      Geolocator.getPositionStream(locationSettings: locationSettings).listen((
        Position position,
      ) {
        latestLocation = position;
      });

  service.on('stopService').listen((event) {
    locationSubscription.cancel();
    service.stopSelf();
  });

  // Sync timer every 2 minutes
  Timer.periodic(const Duration(minutes: 5), (timer) async {
    if (latestLocation != null) {
      final token = prefs.getString(AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        try {
          await trackingRepo.updateLocation(
            latestLocation!.latitude,
            latestLocation!.longitude,
            DateTime.now(),
          );
        } catch (e) {
          // Ignore network errors in background
        }
      } else {
        // No token, stop tracking
        timer.cancel();
        locationSubscription.cancel();
        service.stopSelf();
      }
    }
  });
}
