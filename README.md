# nrel_spa

[![pub package](https://img.shields.io/pub/v/nrel_spa.svg)](https://pub.dev/packages/nrel_spa)
[![CI](https://github.com/acamarata/nrel-spa-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/acamarata/nrel-spa-dart/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

NREL Solar Position Algorithm for Dart and Flutter. Calculates solar zenith, azimuth, sunrise, sunset, and solar noon for any location and time. Pure Dart, zero dependencies.

Based on Reda & Andreas (2004), NREL/TP-560-34302. Accurate to ±0.0003 degrees.

## Installation

```yaml
dependencies:
  nrel_spa: ^1.0.0
```

## Quick Start

```dart
import 'package:nrel_spa/nrel_spa.dart';

void main() {
  final result = getSpa(
    DateTime.utc(2024, 3, 15, 17, 0, 0),
    40.7128,   // latitude (NYC)
    -74.0060,  // longitude
    -5.0,      // UTC offset (EST)
  );

  print('Zenith:     ${result.zenith.toStringAsFixed(4)}°');
  print('Azimuth:    ${result.azimuth.toStringAsFixed(4)}°');
  print('Sunrise:    ${result.sunrise.toStringAsFixed(4)} h');
  print('Solar Noon: ${result.solarNoon.toStringAsFixed(4)} h');
  print('Sunset:     ${result.sunset.toStringAsFixed(4)} h');
}
```

## Custom Zenith Angles

Calculate rise/set times for any solar depression angle (twilight, prayer times, etc.):

```dart
final result = getSpa(
  DateTime.utc(2024, 3, 15, 12, 0, 0),
  40.7128, -74.0060, -5.0,
  customAngles: [96.0, 102.0, 108.0], // civil, nautical, astronomical
);

for (final angle in result.angles) {
  print('Rise: ${angle.sunrise}, Set: ${angle.sunset}');
}
```

## API

### `getSpa(date, latitude, longitude, timezone, {...})`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `date` | `DateTime` | required | UTC date and time |
| `latitude` | `double` | required | Degrees (-90 to 90) |
| `longitude` | `double` | required | Degrees (-180 to 180) |
| `timezone` | `double` | required | Hours from UTC |
| `elevation` | `double` | 0 | Meters above sea level |
| `pressure` | `double` | 1013 | Atmospheric pressure (mbar) |
| `temperature` | `double` | 15 | Temperature (Celsius) |
| `deltaT` | `double` | 67 | TT - UT1 (seconds) |
| `customAngles` | `List<double>` | [] | Zenith angles for rise/set |

Returns `SpaResult` with `zenith`, `azimuth`, `sunrise`, `solarNoon`, `sunset`, and `angles`.

## Architecture

A direct port of the NREL Solar Position Algorithm (Reda & Andreas 2004) to Dart. The implementation follows the original algorithm's 142 intermediate calculations exactly. Custom zenith angles are computed in a single pass alongside the primary solar angles using the same ephemeris state.

## Compatibility

Dart SDK 3.7.0+. Works in Flutter, Dart CLI, and server-side Dart. Zero dependencies.

## Related

- [pray_calc_dart](https://github.com/acamarata/pray-calc-dart) - Islamic prayer times (uses nrel_spa)
- [nrel-spa](https://github.com/acamarata/nrel-spa) - JavaScript/TypeScript version (npm)

## Acknowledgments

> Reda, I. and Andreas, A. (2004). Solar Position Algorithm for Solar Radiation Applications. NREL/TP-560-34302. [DOI: 10.2172/15003974](https://doi.org/10.2172/15003974)

## License

[MIT](LICENSE). See LICENSE for NREL third-party notice.
