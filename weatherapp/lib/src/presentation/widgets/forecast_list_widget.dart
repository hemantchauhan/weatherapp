import 'package:flutter/material.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/presentation/widgets/forecast_item_widget.dart';

class ForecastListWidget extends StatelessWidget {
  final Forecast forecast;

  const ForecastListWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '5-Day Forecast',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forecast.dailyForecasts.length,
          itemBuilder: (context, index) {
            return ForecastItemWidget(forecast: forecast.dailyForecasts[index]);
          },
        ),
      ],
    );
  }
}
