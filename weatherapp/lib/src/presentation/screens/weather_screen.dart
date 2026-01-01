import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/src/presentation/cubit/weather_cubit.dart';
import 'package:weatherapp/src/presentation/cubit/weather_state.dart';
import 'package:weatherapp/src/presentation/widgets/current_weather_widget.dart';
import 'package:weatherapp/src/presentation/widgets/forecast_list_widget.dart';
import 'package:weatherapp/src/presentation/widgets/offline_banner.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<WeatherCubit>().loadWeatherFromLocation();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WeatherLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout
                final isPortrait = constraints.maxHeight > constraints.maxWidth;

                final content =
                    isPortrait
                        ? RefreshIndicator(
                          onRefresh: () async {
                            context.read<WeatherCubit>().refreshWeather();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                CurrentWeatherWidget(
                                  weather: state.currentWeather,
                                ),
                                if (state.forecast != null)
                                  ForecastListWidget(forecast: state.forecast!)
                                else
                                  loadForecastButton(context),
                              ],
                            ),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () async {
                            context.read<WeatherCubit>().refreshWeather();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    child: CurrentWeatherWidget(
                                      weather: state.currentWeather,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                      state.forecast != null
                                          ? ForecastListWidget(
                                            forecast: state.forecast!,
                                          )
                                          : Center(
                                            child: loadForecastButton(context),
                                          ),
                                ),
                              ],
                            ),
                          ),
                        );

                // Show offline banner if data is from cache
                if (state.isFromCache) {
                  return Column(
                    children: [const OfflineBanner(), Expanded(child: content)],
                  );
                }

                return content;
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget loadForecastButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<WeatherCubit>().loadForecast();
          },
          label: const Text('Load 5-Day Forecast'),
        ),
      ),
    );
  }
}
