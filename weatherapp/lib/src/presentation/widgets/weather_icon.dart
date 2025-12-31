import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color color;
  const WeatherIcon({
    super.key,
    required this.icon,
    this.size = 80,
    this.color = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/$icon@2x.png',
      width: size,
      height: size,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.wb_sunny, size: size, color: Colors.yellow);
      },
    );
  }
}
