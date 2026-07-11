import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    try {
      await _location.enableBackgroundMode(enable: true);
    } catch (e) {
      // Background mode may not be supported on all platforms or without extra configuration
    }
    
    // Optimize for periodic updates
    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
      distanceFilter: 10,
    );

    return true;
  }

  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }
}
