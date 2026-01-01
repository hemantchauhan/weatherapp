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
  final bool isFromCache; // If data is from cache

  const WeatherLoaded({
    required this.currentWeather,
    this.forecast,
    this.isFromCache = false,
  });

  WeatherLoaded copyWith({
    Weather? currentWeather,
    Forecast? forecast,
    bool? isFromCache,
  }) {
    return WeatherLoaded(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}

// Error state - something went wrong
class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
}
