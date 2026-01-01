import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

abstract class WeatherLocalDataSource {
  Future<Map<String, dynamic>?> getCachedCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<void> cacheCurrentWeather({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> weatherData,
  });

  Future<Map<String, dynamic>?> getCachedForecast({
    required double latitude,
    required double longitude,
  });

  Future<void> cacheForecast({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> forecastData,
  });

  Future<void> clearCache();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<String> box;
  static const Duration cacheValidDuration = Duration(hours: 1);

  WeatherLocalDataSourceImpl({required this.box});

  String getCacheKey(String prefix, double lat, double lon) {
    return '${prefix}_${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';
  }

  Map<String, dynamic>? parseCachedData(String? cachedJson) {
    if (cachedJson == null) return null;

    try {
      final data = jsonDecode(cachedJson) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int?;

      if (timestamp == null) return null;

      // Check if cache valid
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      if (now.difference(cacheTime) > cacheValidDuration) {
        // Cache expired
        return null;
      }

      return data['data'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheCurrentWeather({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> weatherData,
  }) async {
    final key = getCacheKey('current_weather', latitude, longitude);
    final cacheData = {
      'data': weatherData,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await box.put(key, jsonEncode(cacheData));
  }

  @override
  Future<void> cacheForecast({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> forecastData,
  }) async {
    final key = getCacheKey('forecast', latitude, longitude);
    final cacheData = {
      'data': forecastData,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await box.put(key, jsonEncode(cacheData));
  }

  @override
  Future<Map<String, dynamic>?> getCachedCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final key = getCacheKey('current_weather', latitude, longitude);
    final cachedJson = box.get(key);
    return parseCachedData(cachedJson);
  }

  @override
  Future<Map<String, dynamic>?> getCachedForecast({
    required double latitude,
    required double longitude,
  }) async {
    final key = getCacheKey('forecast', latitude, longitude);
    final cachedJson = box.get(key);
    return parseCachedData(cachedJson);
  }

  @override
  Future<void> clearCache() async {
    await box.clear();
  }
}
