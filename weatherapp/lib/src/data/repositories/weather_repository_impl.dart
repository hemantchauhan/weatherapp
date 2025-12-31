import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/data/datasources/weather_remote_datasource.dart';
import 'package:weatherapp/src/data/models/forecast_model.dart';
import 'package:weatherapp/src/data/models/weather_model.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final json = await remoteDataSource.getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      final model = CurrentWeatherModel.fromJson(json);
      final entity = model.toEntity();

      return Success(entity);
    } catch (e) {
      return Failure(
        e.toString(),
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<Forecast>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final json = await remoteDataSource.get5DayForecast(
        latitude: latitude,
        longitude: longitude,
      );

      final model = ForecastResponseModel.fromJson(json);
      final entity = model.toEntity();

      return Success(entity);
    } catch (e) {
      return Failure(
        e.toString(),
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
