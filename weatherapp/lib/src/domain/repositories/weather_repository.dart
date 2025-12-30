import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<Result<Forecast>> get5DayForecast({
    required double latitude,
    required double longitude,
  });
}
