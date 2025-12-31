import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/presentation/widgets/weather_icon.dart';

class ForecastItemWidget extends StatelessWidget {
  final DailyForecast forecast;

  ForecastItemWidget({super.key, required this.forecast});

  final dateFormat = DateFormat('MMM d');
  final dayFormat = DateFormat('EEEE');

  @override
  Widget build(BuildContext context) {
    final dayName = dayFormat.format(forecast.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Weather Icon
            WeatherIcon(icon: forecast.icon, size: 50),
            const SizedBox(width: 16),
            // Day and Date
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateFormat.format(forecast.date),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Temperature
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${forecast.dayTemperature.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${forecast.minTemperature.toStringAsFixed(1)}° / ${forecast.maxTemperature.toStringAsFixed(1)}°',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  if (forecast.description.isNotEmpty)
                    Text(
                      forecast.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
