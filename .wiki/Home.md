# nrel_spa

NREL Solar Position Algorithm for Dart and Flutter. Calculates solar zenith, azimuth, sunrise, sunset, and solar noon for any location and time. Pure Dart, zero dependencies.

Accurate to +/- 0.0003 degrees. Based on Reda & Andreas (2004), NREL/TP-560-34302.

## Quick Start

```dart
import 'package:nrel_spa/nrel_spa.dart';

final result = getSpa(
  DateTime.utc(2024, 3, 15, 17, 0, 0),
  40.7128,  // latitude
  -74.0060, // longitude
  -5.0,     // UTC offset (EST)
);

print('Zenith:     ${result.zenith.toStringAsFixed(4)}');
print('Azimuth:    ${result.azimuth.toStringAsFixed(4)}');
print('Sunrise:    ${result.sunrise.toStringAsFixed(4)} h');
print('Solar Noon: ${result.solarNoon.toStringAsFixed(4)} h');
print('Sunset:     ${result.sunset.toStringAsFixed(4)} h');
```

## Pages

- [API Reference](API-Reference): Full function and type reference
- [Architecture](Architecture): Algorithm design and implementation notes
