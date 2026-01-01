import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/forecast_entity.dart';
import 'package:weatherapp/src/domain/usecases/get_forecast.dart';

import '../../mock_weather_repository.dart';
import '../../test_data.dart';

void main() {
  late MockWeatherRepository mockRepository;
  late GetForecast useCase;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetForecast(mockRepository);
  });

  tearDown(() {
    mockRepository.reset();
  });

  group('GetForecast', () {
    const testLatitude = 28.4595;
    const testLongitude = 77.0266;

    test(
      'should return forecast data when repository returns success',
      () async {
        // Arrange
        final testForecast = TestData.createTestForecast(
          latitude: testLatitude,
          longitude: testLongitude,
        );
        mockRepository.setGet5DayForecastResult(Success(testForecast));

        // Act
        final result = await useCase.call(
          latitude: testLatitude,
          longitude: testLongitude,
        );

        // Assert
        expect(result, isA<Success<Forecast>>());
        final success = result as Success<Forecast>;
        expect(success.data, equals(testForecast));
        expect(success.data.location.latitude, equals(testLatitude));
        expect(success.data.location.longitude, equals(testLongitude));
        expect(success.data.dailyForecasts.length, equals(5));
        expect(mockRepository.lastLatitude, equals(testLatitude));
        expect(mockRepository.lastLongitude, equals(testLongitude));
      },
    );

    test('should return failure when repository returns failure', () async {
      // Arrange
      const errorMessage = 'Failed to fetch forecast';
      mockRepository.setGet5DayForecastResult(const Failure(errorMessage));

      // Act
      final result = await useCase.call(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Failure<Forecast>>());
      final failure = result as Failure<Forecast>;
      expect(failure.message, equals(errorMessage));
    });

    test(
      'should call repository with correct latitude and longitude',
      () async {
        // Arrange
        const customLat = 51.5074;
        const customLon = -0.1278;
        final testForecast = TestData.createTestForecast(
          latitude: customLat,
          longitude: customLon,
        );
        mockRepository.setGet5DayForecastResult(Success(testForecast));

        // Act
        await useCase.call(latitude: customLat, longitude: customLon);

        // Assert
        expect(mockRepository.lastLatitude, equals(customLat));
        expect(mockRepository.lastLongitude, equals(customLon));
      },
    );

    test('should handle forecast with correct number of days', () async {
      // Arrange
      const daysCount = 5;
      final testForecast = TestData.createTestForecast(
        latitude: testLatitude,
        longitude: testLongitude,
        daysCount: daysCount,
      );
      mockRepository.setGet5DayForecastResult(Success(testForecast));

      // Act
      final result = await useCase.call(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Success<Forecast>>());
      final success = result as Success<Forecast>;
      expect(success.data.dailyForecasts.length, equals(daysCount));
    });
  });
}
