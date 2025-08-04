import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCustomCacheManager {
  static CacheManager instance = CacheManager(
    Config(
      'myCustomCacheKey',
      stalePeriod: const Duration(days: 30), // cache validity
      maxNrOfCacheObjects: 100,
    ),
  );
}
