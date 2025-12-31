import 'package:weatherapp/src/domain/entities/weather_entity.dart';

class CurrentWeatherModel {
  final double lat;
  final double lon;
  final String cityName;
  final String country;

  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final WeatherType condition;
  final String description;
  final String iconCode;
  final DateTime date;

  CurrentWeatherModel({
    required this.lat,
    required this.lon,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.date,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];

    return CurrentWeatherModel(
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      condition: WeatherTypeMapper.fromString(weather['main']),
      description: weather['description'],
      iconCode: weather['icon'],
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
    );
  }

  Weather toEntity() {
    return Weather(
      location: Location(
        cityName: cityName,
        country: country,
        latitude: lat,
        longitude: lon,
      ),
      date: date,
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
      condition: condition,
      description: description,
      icon: iconCode,
    );
  }
}
