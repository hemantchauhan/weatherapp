import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/src/core/cache/hive_constants.dart';

class HiveContainer {
  static Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Open weather cache box
    await Hive.openBox<String>(HiveConstants.weatherCacheBox);
  }

  // Optional: Clear all cache
  static Future<void> clearCache() async {
    final box = Hive.box<String>(HiveConstants.weatherCacheBox);
    await box.clear();
  }
}
