# Quickstart

## Install

Add to `pubspec.yaml`:

```yaml
dependencies:
  nrel_spa: ^1.0.1
```

Run `dart pub get`.

## First Call

```dart
import 'package:nrel_spa/nrel_spa.dart';

void main() {
  final result = getSpa(
    DateTime.utc(2024, 3, 15, 17, 0, 0),
    40.7128,   // latitude (New York)
    -74.0060,  // longitude
    -5.0,      // UTC offset (EST)
  );

  print('Solar zenith:  ${result.zenith.toStringAsFixed(4)}°');
  print('Solar azimuth: ${result.azimuth.toStringAsFixed(4)}°');
  print('Sunrise:       ${result.sunrise.toStringAsFixed(4)} h');
  print('Solar noon:    ${result.solarNoon.toStringAsFixed(4)} h');
  print('Sunset:        ${result.sunset.toStringAsFixed(4)} h');
}
```

## Reading Results

`getSpa` returns an `SpaResult`:

| Field | Type | Description |
| --- | --- | --- |
| `zenith` | `double` | Solar zenith angle (degrees) |
| `azimuth` | `double` | Solar azimuth angle (degrees from north) |
| `sunrise` | `double` | Sunrise time (decimal hours, UTC) |
| `solarNoon` | `double` | Solar noon time (decimal hours, UTC) |
| `sunset` | `double` | Sunset time (decimal hours, UTC) |
| `angles` | `List<AngleResult>` | Rise/set times for custom zenith angles |

## DateTime Input

Always pass UTC `DateTime` values. The `timezone` parameter shifts the output times to local time.

```dart
// Convert local DateTime to UTC before passing
final local = DateTime(2024, 3, 15, 12, 0, 0);
final utc = local.toUtc();
final result = getSpa(utc, lat, lng, utcOffset);
```

## Null Results for Sunrise/Sunset

At polar latitudes or in summer/winter extremes, sunrise or sunset may not occur. In those cases, `result.sunrise` and `result.sunset` return `double.nan`. Always check before displaying:

```dart
if (!result.sunrise.isNaN) {
  print('Sunrise: ${result.sunrise}');
} else {
  print('No sunrise today.');
}
```
