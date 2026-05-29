# Advanced Usage

## Custom Zenith Angles

Calculate rise/set times for any solar depression angle. Useful for computing civil, nautical, and astronomical twilight, or Islamic prayer times.

```dart
import 'package:nrel_spa/nrel_spa.dart';

final result = getSpa(
  DateTime.utc(2024, 3, 15, 12, 0, 0),
  40.7128, -74.0060, -5.0,
  customAngles: [96.0, 102.0, 108.0], // civil, nautical, astronomical
);

for (int i = 0; i < result.angles.length; i++) {
  final a = result.angles[i];
  print('Angle ${a.angle}°: rise=${a.sunrise.toStringAsFixed(4)} h, set=${a.sunset.toStringAsFixed(4)} h');
}
```

Standard zenith angles:

| Twilight type | Zenith angle |
| --- | --- |
| Civil | 96.0° |
| Nautical | 102.0° |
| Astronomical | 108.0° |
| Fajr (18°) | 108.0° |
| Isha (17°) | 107.0° |

## Elevation and Atmospheric Correction

For more accurate results at high elevation or in varying atmospheric conditions:

```dart
final result = getSpa(
  DateTime.utc(2024, 3, 15, 12, 0, 0),
  39.7392,    // Denver latitude
  -104.9903,  // Denver longitude
  -7.0,       // UTC offset (MST)
  elevation: 1609.0,    // meters above sea level
  pressure: 835.0,      // mbar (lower at altitude)
  temperature: 10.0,    // Celsius
);
```

## deltaT Parameter

`deltaT` is the difference between Terrestrial Time (TT) and Universal Time (UT1), in seconds. The default is 67 seconds, which is accurate for recent dates. For historical calculations or projections, supply the correct value from [IERS tables](https://www.iers.org/IERS/EN/Science/EarthRotation/EarthRotation.html).

```dart
// Historical calculation (1990)
final result = getSpa(
  DateTime.utc(1990, 6, 21, 12, 0, 0),
  40.7128, -74.0060, -5.0,
  deltaT: 57.2,
);
```

## Batch Calculations

For high-volume calculations (annual ephemeris, solar energy modeling), call `getSpa` in a loop. The function is synchronous and pure — safe to call from any isolate.

```dart
final times = List.generate(365, (i) {
  final date = DateTime.utc(2024, 1, 1).add(Duration(days: i));
  return getSpa(date, lat, lng, utcOffset);
});
```

For parallel batch work in Flutter, dispatch to an isolate:

```dart
import 'dart:isolate';

final results = await Isolate.run(() {
  return List.generate(365, (i) {
    final date = DateTime.utc(2024, 1, 1).add(Duration(days: i));
    return getSpa(date, lat, lng, utcOffset);
  });
});
```
