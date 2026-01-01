import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';
import 'package:weatherapp/src/domain/usecases/get_current_weather.dart';

import '../../mock_weather_repository.dart';
import '../../test_data.dart';

void main() {
  late MockWeatherRepository mockRepository;
  late GetCurrentWeather useCase;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCurrentWeather(mockRepository);
  });

  tearDown(() {
    mockRepository.reset();
  });

  group('GetCurrentWeather', () {
    const testLatitude = 28.4595;
    const testLongitude = 77.0266;

    test(
      'should return weather data when repository returns success',
      () async {
        // Arrange
        final testWeather = TestData.createTestWeather(
          latitude: testLatitude,
          longitude: testLongitude,
        );
        mockRepository.setGetCurrentWeatherResult(Success(testWeather));

        // Act
        final result = await useCase.call(
          latitude: testLatitude,
          longitude: testLongitude,
        );

        // Assert
        expect(result, isA<Success<Weather>>());
        final success = result as Success<Weather>;
        expect(success.data, equals(testWeather));
        expect(success.data.location.latitude, equals(testLatitude));
        expect(success.data.location.longitude, equals(testLongitude));
        expect(mockRepository.lastLatitude, equals(testLatitude));
        expect(mockRepository.lastLongitude, equals(testLongitude));
      },
    );

    test('should return failure when repository returns failure', () async {
      const errorMessage = 'Failed to fetch weather';
      mockRepository.setGetCurrentWeatherResult(const Failure(errorMessage));

      final result = await useCase.call(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      expect(result, isA<Failure<Weather>>());
      final failure = result as Failure<Weather>;
      expect(failure.message, equals(errorMessage));
    });

    test(
      'should call repository with correct latitude and longitude',
      () async {
        const customLat = 51.5074;
        const customLon = -0.1278;
        final testWeather = TestData.createTestWeather(
          latitude: customLat,
          longitude: customLon,
        );
        mockRepository.setGetCurrentWeatherResult(Success(testWeather));

        await useCase.call(latitude: customLat, longitude: customLon);

        expect(mockRepository.lastLatitude, equals(customLat));
        expect(mockRepository.lastLongitude, equals(customLon));
      },
    );

    test('should propagate repository errors correctly', () async {
      final testException = Exception('Network error');
      mockRepository.setGetCurrentWeatherResult(
        Failure('Network error', testException),
      );

      final result = await useCase.call(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      expect(result, isA<Failure<Weather>>());
      final failure = result as Failure<Weather>;
      expect(failure.message, equals('Network error'));
      expect(failure.error, equals(testException));
    });
  });
}
