# Basic Usage Examples

## Sunrise and Sunset for a City

```dart
import 'package:nrel_spa/nrel_spa.dart';

void printSolarDay(String city, double lat, double lng, double utcOffset) {
  final now = DateTime.now().toUtc();
  final result = getSpa(now, lat, lng, utcOffset);

  String fmt(double h) {
    if (h.isNaN) return 'n/a';
    final hh = h.truncate();
    final mm = ((h - hh) * 60).round();
    return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}';
  }

  print('$city');
  print('  Sunrise:    ${fmt(result.sunrise)}');
  print('  Solar noon: ${fmt(result.solarNoon)}');
  print('  Sunset:     ${fmt(result.sunset)}');
  print('  Zenith now: ${result.zenith.toStringAsFixed(2)}°');
}

void main() {
  printSolarDay('New York',  40.7128,  -74.0060, -5.0);
  printSolarDay('London',    51.5074,   -0.1278,   0.0);
  printSolarDay('Makkah',    21.3891,   39.8579,   3.0);
  printSolarDay('Melbourne', -37.8136, 144.9631,  10.0);
}
```

## Annual Solar Noon Curve

```dart
import 'package:nrel_spa/nrel_spa.dart';

void main() {
  const lat = 40.7128;
  const lng = -74.0060;
  const utcOffset = -5.0;

  print('Day,SolarNoon');
  for (int day = 1; day <= 365; day++) {
    final date = DateTime.utc(2024, 1, 1).add(Duration(days: day - 1));
    final result = getSpa(date.add(const Duration(hours: 12)), lat, lng, utcOffset);
    print('$day,${result.solarNoon.toStringAsFixed(6)}');
  }
}
```

## Twilight Times for Prayer Calculation

```dart
import 'package:nrel_spa/nrel_spa.dart';

void main() {
  final date = DateTime.utc(2024, 3, 15, 12, 0, 0);
  const lat = 33.8938;   // Jerusalem
  const lng = 35.5018;
  const utcOffset = 2.0; // EET

  final result = getSpa(
    date, lat, lng, utcOffset,
    customAngles: [108.0, 107.0], // Fajr 18°, Isha 17°
  );

  print('Fajr  (18°): ${result.angles[0].sunrise.toStringAsFixed(4)} h');
  print('Isha  (17°): ${result.angles[1].sunset.toStringAsFixed(4)} h');
  print('Sunrise:     ${result.sunrise.toStringAsFixed(4)} h');
  print('Sunset:      ${result.sunset.toStringAsFixed(4)} h');
}
```
