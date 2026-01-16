import 'package:weatherapp/src/core/network/http_client.dart';

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
  final HttpClient client;
  final String apiKey;
  final String baseUrl;

  WeatherRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
    this.baseUrl = 'https://api.openweathermap.org/data/2.5',
  });

  @override
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await client.get(
      url: '$baseUrl/weather',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> get5DayForecast({
    required double latitude,
    required double longitude,
  }) async {
    final response = await client.get(
      url: '$baseUrl/forecast',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return response.data;
  }
}
