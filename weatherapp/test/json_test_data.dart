class JsonTestData {
  static Map<String, dynamic> createCurrentWeatherJson({
    double latitude = 28.4595,
    double longitude = 77.0266,
    String cityName = 'Gurugram',
    String country = 'Haryana',
    double temperature = 10.5,
    int humidity = 65,
    double windSpeed = 3.2,
  }) {
    return {
      'coord': {'lat': latitude, 'lon': longitude},
      'weather': [
        {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
      ],
      'main': {'temp': temperature, 'feels_like': 10.8, 'humidity': humidity},
      'wind': {'speed': windSpeed},
      'name': cityName,
      'sys': {'country': country},
      'dt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }

  static Map<String, dynamic> createForecastJson({
    double latitude = 28.4595,
    double longitude = 77.0266,
    String cityName = 'Gurugram',
    String country = 'Haryana',
  }) {
    final now = DateTime.now();
    return {
      'city': {
        'name': cityName,
        'country': country,
        'coord': {'lat': latitude, 'lon': longitude},
      },
      'list': List.generate(
        40, // OpenWeatherMap returns 40 entries for 5 days
        (index) => {
          'dt':
              now.add(Duration(hours: index * 3)).millisecondsSinceEpoch ~/
              1000,
          'main': {
            'temp': 10.0 + index * 0.1,
            'feels_like': 19.0 + index * 0.1,
            'temp_min': 10.0 + index * 0.1,
            'temp_max': 20.0 + index * 0.1,
            'humidity': 65,
          },
          'weather': [
            {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
          ],
          'wind': {'speed': 3.2},
        },
      ),
    };
  }
}
