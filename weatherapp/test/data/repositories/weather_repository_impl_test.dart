import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/src/core/utils/result.dart';
import 'package:weatherapp/src/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/src/domain/entities/weather_entity.dart';

import '../../json_test_data.dart';
import '../../mock_data_sources.dart';

void main() {
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late MockWeatherLocalDataSource mockLocalDataSource;
  late WeatherRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    mockLocalDataSource = MockWeatherLocalDataSource();
    repository = WeatherRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  tearDown(() {
    mockRemoteDataSource.reset();
    mockLocalDataSource.reset();
  });

  group('WeatherRepositoryImpl - getCurrentWeather', () {
    const testLatitude = 28.4595;
    const testLongitude = 77.0266;

    test('should return cached data when cache is available', () async {
      // Arrange
      final cachedJson = JsonTestData.createCurrentWeatherJson(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      mockLocalDataSource.setCachedCurrentWeather(cachedJson);

      // Act
      final result = await repository.getCurrentWeather(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Success<Weather>>());
      final success = result as Success<Weather>;
      expect(success.data.location.latitude, equals(testLatitude));
      expect(success.data.location.longitude, equals(testLongitude));
    });

    test('should fetch from API when cache is not available', () async {
      // Arrange
      mockLocalDataSource.setCachedCurrentWeather(null); // No cache
      final apiJson = JsonTestData.createCurrentWeatherJson(
        latitude: testLatitude,
        longitude: testLongitude,
        temperature: 25.0,
      );
      mockRemoteDataSource.setGetCurrentWeatherResponse(apiJson);

      // Act
      final result = await repository.getCurrentWeather(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Success<Weather>>());
      final success = result as Success<Weather>;
      expect(success.data.temperature, equals(25.0));
    });

    test('should cache data after fetching from API', () async {
      // Arrange
      mockLocalDataSource.setCachedCurrentWeather(null); // No cache
      final apiJson = JsonTestData.createCurrentWeatherJson(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      mockRemoteDataSource.setGetCurrentWeatherResponse(apiJson);

      // Act
      await repository.getCurrentWeather(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(mockLocalDataSource.lastCachedLatitude, equals(testLatitude));
      expect(mockLocalDataSource.lastCachedLongitude, equals(testLongitude));
      // Verify cached data matches API response
      final cachedData = await mockLocalDataSource.getCachedCurrentWeather(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      expect(cachedData, isNotNull);
    });

    test(
      'should return failure when API fails and no cache available',
      () async {
        // Arrange
        mockLocalDataSource.setCachedCurrentWeather(null); // No cache
        final exception = Exception('Network error');
        mockRemoteDataSource.setGetCurrentWeatherException(exception);

        // Act
        final result = await repository.getCurrentWeather(
          latitude: testLatitude,
          longitude: testLongitude,
        );

        // Assert
        expect(result, isA<Failure<Weather>>());
        final failure = result as Failure<Weather>;
        expect(failure.message, contains('Network error'));
      },
    );

    test('should call datasources with correct parameters', () async {
      // Arrange
      const customLat = 51.5074;
      const customLon = -0.1278;
      mockLocalDataSource.setCachedCurrentWeather(null);
      final apiJson = JsonTestData.createCurrentWeatherJson(
        latitude: customLat,
        longitude: customLon,
      );
      mockRemoteDataSource.setGetCurrentWeatherResponse(apiJson);

      // Act
      await repository.getCurrentWeather(
        latitude: customLat,
        longitude: customLon,
      );

      // Assert
      expect(mockRemoteDataSource.lastLatitude, equals(customLat));
      expect(mockRemoteDataSource.lastLongitude, equals(customLon));
      expect(mockLocalDataSource.lastCachedLatitude, equals(customLat));
      expect(mockLocalDataSource.lastCachedLongitude, equals(customLon));
    });
  });

  group('WeatherRepositoryImpl - get5DayForecast', () {
    const testLatitude = 28.4595;
    const testLongitude = 77.0266;

    test('should return cached forecast when cache is available', () async {
      // Arrange
      final cachedJson = JsonTestData.createForecastJson(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      mockLocalDataSource.setCachedForecast(cachedJson);

      // Act
      final result = await repository.get5DayForecast(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Success>());
    });

    test('should fetch from API when cache is not available', () async {
      // Arrange
      mockLocalDataSource.setCachedForecast(null); // No cache
      final apiJson = JsonTestData.createForecastJson(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      mockRemoteDataSource.setGet5DayForecastResponse(apiJson);

      // Act
      final result = await repository.get5DayForecast(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      expect(result, isA<Success>());
    });

    test('should cache forecast after fetching from API', () async {
      // Arrange
      mockLocalDataSource.setCachedForecast(null); // No cache
      final apiJson = JsonTestData.createForecastJson(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      mockRemoteDataSource.setGet5DayForecastResponse(apiJson);

      // Act
      await repository.get5DayForecast(
        latitude: testLatitude,
        longitude: testLongitude,
      );

      // Assert
      // Verify cached data
      final cachedData = await mockLocalDataSource.getCachedForecast(
        latitude: testLatitude,
        longitude: testLongitude,
      );
      expect(cachedData, isNotNull);
    });

    test(
      'should return failure when API fails and no cache available',
      () async {
        // Arrange
        mockLocalDataSource.setCachedForecast(null); // No cache
        final exception = Exception('Network error');
        mockRemoteDataSource.setGet5DayForecastException(exception);

        // Act
        final result = await repository.get5DayForecast(
          latitude: testLatitude,
          longitude: testLongitude,
        );

        // Assert
        expect(result, isA<Failure>());
        final failure = result as Failure;
        expect(failure.message, contains('Network error'));
      },
    );

    test(
      'should call datasources with correct parameters for forecast',
      () async {
        // Arrange
        const customLat = testLatitude;
        const customLon = testLongitude;
        mockLocalDataSource.setCachedForecast(null);
        final apiJson = JsonTestData.createForecastJson(
          latitude: customLat,
          longitude: customLon,
        );
        mockRemoteDataSource.setGet5DayForecastResponse(apiJson);

        // Act
        await repository.get5DayForecast(
          latitude: customLat,
          longitude: customLon,
        );

        // Assert
        expect(mockRemoteDataSource.lastLatitude, equals(customLat));
        expect(mockRemoteDataSource.lastLongitude, equals(customLon));
      },
    );
  });
}
