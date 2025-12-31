import 'package:dio/dio.dart';

abstract class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<Map<String, dynamic>> get5DayForecast({
    required double latitude,
    required double longitude,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  final String apiKey;
  final String baseUrl;

  WeatherRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
    this.baseUrl = 'https://api.openweathermap.org/data/2.5',
  });

  @override
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch current weather: ${e.message ?? 'Unknown error'}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/forecast',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch forecast: ${e.message ?? 'Unknown error'}',
      );
    }
  }
}
