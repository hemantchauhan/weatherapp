import 'package:weatherapp/src/data/datasources/weather_local_datasource.dart';
import 'package:weatherapp/src/data/datasources/weather_remote_datasource.dart';

class MockWeatherRemoteDataSource implements WeatherRemoteDataSource {
  Map<String, dynamic>? _getCurrentWeatherResponse;
  Map<String, dynamic>? _get5DayForecastResponse;
  Exception? _getCurrentWeatherException;
  Exception? _get5DayForecastException;

  double? lastLatitude;
  double? lastLongitude;

  void setGetCurrentWeatherResponse(Map<String, dynamic> response) {
    _getCurrentWeatherResponse = response;
    _getCurrentWeatherException = null;
  }

  void setGetCurrentWeatherException(Exception exception) {
    _getCurrentWeatherException = exception;
    _getCurrentWeatherResponse = null;
  }

  void setGet5DayForecastResponse(Map<String, dynamic> response) {
    _get5DayForecastResponse = response;
    _get5DayForecastException = null;
  }

  void setGet5DayForecastException(Exception exception) {
    _get5DayForecastException = exception;
    _get5DayForecastResponse = null;
  }

  void reset() {
    _getCurrentWeatherResponse = null;
    _get5DayForecastResponse = null;
    _getCurrentWeatherException = null;
    _get5DayForecastException = null;
    lastLatitude = null;
    lastLongitude = null;
  }

  @override
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;

    if (_getCurrentWeatherException != null) {
      throw _getCurrentWeatherException!;
    }

    if (_getCurrentWeatherResponse == null) {
      throw Exception(
        'Mock remote datasource not configured for getCurrentWeather',
      );
    }

    return _getCurrentWeatherResponse!;
  }

  @override
  Future<Map<String, dynamic>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;

    if (_get5DayForecastException != null) {
      throw _get5DayForecastException!;
    }

    if (_get5DayForecastResponse == null) {
      throw Exception(
        'Mock remote datasource not configured for get5DayForecast',
      );
    }

    return _get5DayForecastResponse!;
  }
}

class MockWeatherLocalDataSource implements WeatherLocalDataSource {
  Map<String, dynamic>? _cachedCurrentWeather;
  Map<String, dynamic>? _cachedForecast;

  double? lastCachedLatitude;
  double? lastCachedLongitude;

  void setCachedCurrentWeather(Map<String, dynamic>? data) {
    _cachedCurrentWeather = data;
  }

  void setCachedForecast(Map<String, dynamic>? data) {
    _cachedForecast = data;
  }

  void reset() {
    _cachedCurrentWeather = null;
    _cachedForecast = null;
    lastCachedLatitude = null;
    lastCachedLongitude = null;
  }

  @override
  Future<Map<String, dynamic>?> getCachedCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    return _cachedCurrentWeather;
  }

  @override
  Future<void> cacheCurrentWeather({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> weatherData,
  }) async {
    lastCachedLatitude = latitude;
    lastCachedLongitude = longitude;
    _cachedCurrentWeather = weatherData;
  }

  @override
  Future<Map<String, dynamic>?> getCachedForecast({
    required double latitude,
    required double longitude,
  }) async {
    return _cachedForecast;
  }

  @override
  Future<void> cacheForecast({
    required double latitude,
    required double longitude,
    required Map<String, dynamic> forecastData,
  }) async {
    _cachedForecast = forecastData;
  }

  @override
  Future<void> clearCache() async {
    _cachedCurrentWeather = null;
    _cachedForecast = null;
  }
}
