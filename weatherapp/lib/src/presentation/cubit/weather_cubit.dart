import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/src/core/services/location_service.dart';
import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/usecases/get_current_weather.dart';
import 'package:weatherapp/src/domain/usecases/get_forecast.dart';
import 'package:weatherapp/src/presentation/cubit/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetForecast getForecast;
  final LocationService locationService;

  WeatherCubit({
    required this.getCurrentWeather,
    required this.getForecast,
    required this.locationService,
  }) : super(const WeatherLoading());

  Future<void> loadWeatherFromLocation() async {
    emit(const WeatherLoading());

    // Get device location
    final locationResult = await locationService.getCurrentLocation();

    if (locationResult is Failure) {
      emit(WeatherError((locationResult as Failure).message));
      return;
    }

    final coordinates = (locationResult as Success).data;
    await _loadWeatherData(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  }

  Future<void> loadWeather({
    required double latitude,
    required double longitude,
  }) async {
    emit(const WeatherLoading());
    await _loadWeatherData(latitude: latitude, longitude: longitude);
  }

  Future<void> refreshWeather() async {
    final currentState = state;

    if (currentState is WeatherLoaded) {
      final location = currentState.currentWeather.location;
      await loadWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    } else {
      await loadWeatherFromLocation();
    }
  }

  Future<void> loadForecast() async {
    final currentState = state;

    if (currentState is! WeatherLoaded) {
      // First load weather data
      await loadWeatherFromLocation();
      return;
    }

    final location = currentState.currentWeather.location;

    // Don't reload, If forecast already available,
    if (currentState.forecast != null) {
      return;
    }

    // Load forecast
    final forecastResult = await getForecast.call(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    if (forecastResult is Failure) {
      // Forecast is optional
      return;
    }

    final forecast = (forecastResult as Success).data;

    // Update state with forecast
    emit(currentState.copyWith(forecast: forecast));
  }

  Future<void> _loadWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    // Load current weather
    final weatherResult = await getCurrentWeather.call(
      latitude: latitude,
      longitude: longitude,
    );

    if (weatherResult is Failure) {
      emit(WeatherError((weatherResult as Failure).message));
      return;
    }

    final weather = (weatherResult as Success).data;

    emit(WeatherLoaded(currentWeather: weather));
  }
}
