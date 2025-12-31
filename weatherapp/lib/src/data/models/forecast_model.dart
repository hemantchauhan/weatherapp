import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';

class ForecastResponseModel {
  final CityInfoModel city;
  final List<ForecastModel> items;

  ForecastResponseModel({required this.city, required this.items});

  factory ForecastResponseModel.fromJson(Map<String, dynamic> json) {
    return ForecastResponseModel(
      city: CityInfoModel.fromJson(json['city']),
      items:
          (json['list'] as List)
              .map((item) => ForecastModel.fromJson(item))
              .toList(),
    );
  }

  Forecast toEntity() {
    // group items by date
    final Map<String, List<ForecastModel>> byDay = {};

    for (final item in items) {
      final key = "${item.date.year}-${item.date.month}-${item.date.day}";
      byDay.putIfAbsent(key, () => []).add(item);
    }

    final List<DailyForecast> dailyForecasts = [];

    for (final entry in byDay.entries) {
      final group = entry.value;

      group.sort((a, b) => a.date.compareTo(b.date));

      double minTemp = group.first.minTemp;
      double maxTemp = group.first.maxTemp;

      for (final g in group) {
        if (g.minTemp < minTemp) minTemp = g.minTemp;
        if (g.maxTemp > maxTemp) maxTemp = g.maxTemp;
      }
      // average 12:00 PM forecast
      ForecastModel firstModel = group.first;

      for (final g in group) {
        if (g.date.hour == 12) {
          firstModel = g;
          break;
        }
      }

      dailyForecasts.add(
        DailyForecast(
          date: firstModel.date,
          maxTemperature: maxTemp,
          minTemperature: minTemp,
          dayTemperature: firstModel.temperature,
          condition: firstModel.condition,
          description: firstModel.description,
          icon: firstModel.icon,
        ),
      );
    }

    dailyForecasts.sort((a, b) => a.date.compareTo(b.date));

    // Limit to 5 days (requirement)
    final trimmed = dailyForecasts.take(5).toList();

    return Forecast(
      location: Location(
        cityName: city.name,
        country: city.country,
        latitude: city.lat,
        longitude: city.lon,
      ),
      dailyForecasts: trimmed,
    );
  }
}

class CityInfoModel {
  final String name;
  final String country;
  final double lat;
  final double lon;

  CityInfoModel({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory CityInfoModel.fromJson(Map<String, dynamic> json) {
    return CityInfoModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
    );
  }
}

class ForecastModel {
  final DateTime date;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final double windSpeed;

  final WeatherType condition;
  final String description;
  final String icon;

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];

    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      condition: WeatherTypeMapper.fromString(weather['main']),
      description: weather['description'],
      icon: weather['icon'],
    );
  }
}
