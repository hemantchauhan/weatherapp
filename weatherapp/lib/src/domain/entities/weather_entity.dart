enum WeatherType {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  mist,
  fog,
  unknown,
}

class WeatherTypeMapper {
  static WeatherType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'clear':
        return WeatherType.clear;
      case 'clouds':
        return WeatherType.clouds;
      case 'rain':
        return WeatherType.rain;
      case 'drizzle':
        return WeatherType.drizzle;
      case 'thunderstorm':
        return WeatherType.thunderstorm;
      case 'snow':
        return WeatherType.snow;
      case 'mist':
        return WeatherType.mist;
      case 'fog':
        return WeatherType.fog;
      default:
        return WeatherType.unknown;
    }
  }
}

class Location {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;

  const Location({
    required this.cityName,
    this.country = "",
    required this.latitude,
    required this.longitude,
  });
}

class Weather {
  final Location location;
  final DateTime date;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final WeatherType condition;
  final String description;
  final String icon;

  const Weather({
    required this.location,
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.icon,
  });
}
