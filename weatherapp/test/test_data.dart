import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';

class TestData {
  static Weather createTestWeather({
    double latitude = 28.4595,
    double longitude = 77.0266,
    String cityName = 'Gurugram',
    String country = 'Haryana',
    double temperature = 15.5,
    int humidity = 65,
    double windSpeed = 3.2,
  }) {
    return Weather(
      location: Location(
        cityName: cityName,
        country: country,
        latitude: latitude,
        longitude: longitude,
      ),
      date: DateTime(2024, 1, 1, 12, 0),
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
      condition: WeatherType.clear,
      description: 'clear sky',
      icon: '01d',
    );
  }

  static Forecast createTestForecast({
    double latitude = 28.4595,
    double longitude = 77.0266,
    String cityName = 'Gurugram',
    String country = 'Haryana',
    int daysCount = 5,
  }) {
    final dailyForecasts = List.generate(
      daysCount,
      (index) => DailyForecast(
        date: DateTime(2024, 1, 1).add(Duration(days: index)),
        maxTemperature: 20.0 + index,
        minTemperature: 10.0 + index,
        dayTemperature: 15.0 + index,
        condition: WeatherType.clear,
        description: 'clear sky',
        icon: '01d',
      ),
    );

    return Forecast(
      location: Location(
        cityName: cityName,
        country: country,
        latitude: latitude,
        longitude: longitude,
      ),
      dailyForecasts: dailyForecasts,
    );
  }
}
