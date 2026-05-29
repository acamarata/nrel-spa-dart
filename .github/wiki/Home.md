# nrel_spa

NREL Solar Position Algorithm for Dart and Flutter. Calculates solar zenith, azimuth, sunrise, sunset, and solar noon for any location and time. Pure Dart, zero dependencies, accurate to ±0.0003 degrees.

Based on Reda & Andreas (2004), NREL/TP-560-34302.

## Install

```yaml
dependencies:
  nrel_spa: ^1.0.1
```

```dart
import 'package:nrel_spa/nrel_spa.dart';

final result = getSpa(
  DateTime.utc(2024, 3, 15, 17, 0, 0),
  40.7128,   // latitude
  -74.0060,  // longitude
  -5.0,      // UTC offset (EST)
);

print('Zenith:  ${result.zenith.toStringAsFixed(4)}°');
print('Sunrise: ${result.sunrise.toStringAsFixed(4)} h');
```

## Contents

- [Quickstart Guide](guides/quickstart) — install, first call, common patterns
- [Advanced Usage](guides/advanced) — custom zenith angles, elevation, atmospheric correction
- [API Reference](API-Reference) — full function and type reference
- [Examples](examples/basic-usage) — real-world snippets
- [Contributing](CONTRIBUTING)
