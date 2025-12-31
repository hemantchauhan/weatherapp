import 'package:weatherapp/src/core/utils/result.dart';
import 'package:geolocator/geolocator.dart';

class LocationCoordinates {
  final double latitude;
  final double longitude;

  const LocationCoordinates({required this.latitude, required this.longitude});
}

abstract class LocationService {
  Future<bool> isPermissionGranted();

  Future<bool> requestPermission();

  Future<Result<LocationCoordinates>> getCurrentLocation();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<bool> isPermissionGranted() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, cannot request permissions
      return false;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<Result<LocationCoordinates>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Failure(
          'Location services are disabled. Please enable location services in your device settings.',
        );
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Failure(
            'Location permissions are denied. Please grant location permissions to use this feature.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Failure(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return Success(
        LocationCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on LocationServiceDisabledException {
      return const Failure(
        'Location services are disabled. Please enable location services in your device settings.',
      );
    } catch (e) {
      return Failure(
        'Failed to get location: ${e.toString()}',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
