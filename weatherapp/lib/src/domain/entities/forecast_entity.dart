import 'package:weatherapp/src/domain/entities/weather_entity.dart';

class DailyForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final double dayTemperature;
  final WeatherType condition;
  final String description;
  final String icon;

  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.dayTemperature,
    required this.condition,
    required this.description,
    required this.icon,
  });
}

class Forecast {
  final Location location;
  final List<DailyForecast> dailyForecasts;

  const Forecast({required this.location, required this.dailyForecasts});
}
