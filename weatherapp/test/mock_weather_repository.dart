import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';

class MockWeatherRepository implements WeatherRepository {
  Result<Weather>? _getCurrentWeatherResult;
  Result<Forecast>? _get5DayForecastResult;

  double? lastLatitude;
  double? lastLongitude;

  void setGetCurrentWeatherResult(Result<Weather> result) {
    _getCurrentWeatherResult = result;
  }

  void setGet5DayForecastResult(Result<Forecast> result) {
    _get5DayForecastResult = result;
  }

  void reset() {
    _getCurrentWeatherResult = null;
    _get5DayForecastResult = null;
    lastLatitude = null;
    lastLongitude = null;
  }

  @override
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;

    if (_getCurrentWeatherResult == null) {
      throw Exception('Mock repository not configured for getCurrentWeather');
    }

    return Future.value(_getCurrentWeatherResult!);
  }

  @override
  Future<Result<Forecast>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;

    if (_get5DayForecastResult == null) {
      throw Exception('Mock repository not configured for get5DayForecast');
    }

    return Future.value(_get5DayForecastResult!);
  }
}
