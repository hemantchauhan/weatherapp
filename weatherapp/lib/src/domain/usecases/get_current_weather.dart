import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Result<Weather>> call({
    required double latitude,
    required double longitude,
  }) async {
    return repository.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
