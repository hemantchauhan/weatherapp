import 'package:dio/dio.dart';
import 'package:weatherapp/src/core/utils/error_mapper.dart';
import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/data/datasources/weather_local_datasource.dart';
import 'package:weatherapp/src/data/datasources/weather_remote_datasource.dart';
import 'package:weatherapp/src/data/models/forecast_model.dart';
import 'package:weatherapp/src/data/models/weather_model.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      if (cachedData != null) {
        final model = CurrentWeatherModel.fromJson(cachedData);
        final entity = model.toEntity();
        return Success(entity);
      }

      // Otherwise fetch from remote
      final json = await remoteDataSource.getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      // Cache the responae
      await localDataSource.cacheCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        weatherData: json,
      );

      final model = CurrentWeatherModel.fromJson(json);
      final entity = model.toEntity();

      return Success(entity);
    } on DioException catch (e) {
      return Failure(ErrorMapper.mapDioException(e), e);
    } on Exception catch (e) {
      return Failure(e.toString().replaceFirst('Exception: ', ''), e);
    } catch (e) {
      return Failure(
        'An unexpected error occurred: ${e.toString()}',
        Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<Forecast>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedForecast(
        latitude: latitude,
        longitude: longitude,
      );

      if (cachedData != null) {
        final model = ForecastResponseModel.fromJson(cachedData);
        final entity = model.toEntity();
        return Success(entity);
      }

      // Otherwise fetch from remote
      final json = await remoteDataSource.get5DayForecast(
        latitude: latitude,
        longitude: longitude,
      );

      // Cache the response
      await localDataSource.cacheForecast(
        latitude: latitude,
        longitude: longitude,
        forecastData: json,
      );

      final model = ForecastResponseModel.fromJson(json);
      final entity = model.toEntity();

      return Success(entity);
    } on DioException catch (e) {
      return Failure(ErrorMapper.mapDioException(e), e);
    } on Exception catch (e) {
      return Failure(e.toString().replaceFirst('Exception: ', ''), e);
    } catch (e) {
      return Failure(
        'An unexpected error occurred: ${e.toString()}',
        Exception(e.toString()),
      );
    }
  }
}
