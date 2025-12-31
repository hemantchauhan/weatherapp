import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';

// Base sealed class for weather states
sealed class WeatherState {
  const WeatherState();
}

// Loading state - fetching weather data
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

// Success state - weather data loaded successfully
class WeatherLoaded extends WeatherState {
  final Weather currentWeather;
  final Forecast? forecast;

  const WeatherLoaded({required this.currentWeather, this.forecast});

  WeatherLoaded copyWith({Weather? currentWeather, Forecast? forecast}) {
    return WeatherLoaded(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
    );
  }
}

// Error state - something went wrong
class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
}
