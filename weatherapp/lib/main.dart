import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/src/core/di/di_container.dart' as di;
import 'package:weatherapp/src/presentation/cubit/weather_cubit.dart';
import 'package:weatherapp/src/presentation/screens/weather_screen.dart';

void main() async {
  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: BlocProvider(
        create:
            (context) => di.getIt<WeatherCubit>()..loadWeatherFromLocation(),
        child: const WeatherScreen(),
      ),
    );
  }
}
