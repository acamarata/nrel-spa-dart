# Prayer Times Integration

This example shows how to use `nrel_spa` inside a Flutter app to build a solar-position widget. It computes the current solar zenith and the times for sunrise, solar noon, and sunset, then displays them in a card.

## Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  nrel_spa: ^1.0.0
  geolocator: ^14.0.0
```

## SolarDayCard Widget

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nrel_spa/nrel_spa.dart';

class SolarDayCard extends StatefulWidget {
  const SolarDayCard({super.key});

  @override
  State<SolarDayCard> createState() => _SolarDayCardState();
}

class _SolarDayCardState extends State<SolarDayCard> {
  SpaFormattedResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _compute();
  }

  Future<void> _compute() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _error = 'Location permission denied.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      final now = DateTime.now().toUtc();
      final utcOffset = DateTime.now().timeZoneOffset.inMinutes / 60.0;

      // calcSpa returns pre-formatted HH:MM:SS strings for the time fields.
      final result = calcSpa(now, pos.latitude, pos.longitude, utcOffset);
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $_error'),
      ));
    }

    if (_result == null) {
      return const Card(child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ));
    }

    final r = _result!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solar Day', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _row('Sunrise', r.sunrise),
            _row('Solar noon', r.solarNoon),
            _row('Sunset', r.sunset),
            _row('Zenith now', '${r.zenith.toStringAsFixed(2)}°'),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    ),
  );
}
```

## Custom Zenith Angles for Twilight

The `customAngles` parameter lets you request rise and set times at any zenith angle. This is useful for civil twilight (96°), nautical twilight (102°), and Islamic twilight used in prayer-time calculation (Fajr at 108°, Isha at 107°).

```dart
import 'package:nrel_spa/nrel_spa.dart';

void printTwilight(double lat, double lng, double utcOffset) {
  final date = DateTime.now().toUtc();

  // spaZaRts (default) computes rise/transit/set. Required for customAngles.
  final r = getSpa(
    date, lat, lng, utcOffset,
    functionCode: spaZaRts,
    customAngles: [96.0, 102.0, 108.0],
  );

  print('Civil twilight begin:    ${r.angles[0].sunrise.toStringAsFixed(4)} h');
  print('Nautical twilight begin: ${r.angles[1].sunrise.toStringAsFixed(4)} h');
  print('Fajr (18°) begin:        ${r.angles[2].sunrise.toStringAsFixed(4)} h');
  print('Fajr (18°) end:          ${r.angles[2].sunset.toStringAsFixed(4)} h');
  print('Nautical twilight end:   ${r.angles[1].sunset.toStringAsFixed(4)} h');
  print('Civil twilight end:      ${r.angles[0].sunset.toStringAsFixed(4)} h');
}

void main() {
  printTwilight(40.7128, -74.006, -5.0); // New York, EST
}
```
