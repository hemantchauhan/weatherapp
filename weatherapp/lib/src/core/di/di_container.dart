import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/src/core/cache/hive_constants.dart';
import 'package:weatherapp/src/core/services/location_service.dart';
import 'package:weatherapp/src/data/datasources/weather_local_datasource.dart';
import 'package:weatherapp/src/data/datasources/weather_remote_datasource.dart';
import 'package:weatherapp/src/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/src/domain/repositories/weather_repository.dart';
import 'package:weatherapp/src/domain/usecases/get_current_weather.dart';
import 'package:weatherapp/src/domain/usecases/get_forecast.dart';
import 'package:weatherapp/src/presentation/cubit/weather_cubit.dart';

final getIt = GetIt.instance;

// Initialize dependency injection
Future<void> init() async {
  // Dio instance
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  const String apiKey =
      '3ae9e752fb7aae1fb6c4e8ae01647e98'; // TODO: Move to environment config

  // Data sources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dio: getIt<Dio>(), apiKey: apiKey),
  );

  // Local data source (cache)
  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      box: Hive.box<String>(HiveConstants.weatherCacheBox),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      getIt<WeatherRemoteDataSource>(),
      getIt<WeatherLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetCurrentWeather>(
    () => GetCurrentWeather(getIt<WeatherRepository>()),
  );

  getIt.registerLazySingleton<GetForecast>(
    () => GetForecast(getIt<WeatherRepository>()),
  );

  // Services
  getIt.registerLazySingleton<LocationService>(() => LocationServiceImpl());

  // Cubits/Blocs
  getIt.registerFactory<WeatherCubit>(
    () => WeatherCubit(
      getCurrentWeather: getIt<GetCurrentWeather>(),
      getForecast: getIt<GetForecast>(),
      locationService: getIt<LocationService>(),
    ),
  );
}
