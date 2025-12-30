import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<Result<Forecast>> call({
    required double latitude,
    required double longitude,
  }) async {
    return repository.get5DayForecast(latitude: latitude, longitude: longitude);
  }
}
