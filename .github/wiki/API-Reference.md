# API Reference

## getSpa

```dart
SpaResult getSpa(
  DateTime date,
  double latitude,
  double longitude,
  double timezone, {
  double elevation = 0,
  double pressure = 1013,
  double temperature = 15,
  double deltaT = 67,
  List<double> customAngles = const [],
})
```

Computes solar position for a given location and moment.

### Parameters

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
| `customAngles` | `List<double>` | [] | Zenith angles for custom rise/set computation |

### SpaResult fields

| Field | Type | Description |
| --- | --- | --- |
| `zenith` | `double` | Solar zenith angle (degrees) |
| `azimuth` | `double` | Solar azimuth angle (degrees, clockwise from north) |
| `sunrise` | `double` | Sunrise in fractional hours (local time) |
| `solarNoon` | `double` | Solar noon in fractional hours (local time) |
| `sunset` | `double` | Sunset in fractional hours (local time) |
| `angles` | `List<SpaAngleResult>` | Rise/set pairs for each entry in `customAngles` |

### SpaAngleResult fields

| Field | Type | Description |
| --- | --- | --- |
| `zenith` | `double` | The requested zenith angle |
| `sunrise` | `double` | Rise time in fractional hours for this zenith |
| `sunset` | `double` | Set time in fractional hours for this zenith |

### Custom zenith angles

Pass any solar zenith angles to get rise/set times at those angles. Standard civil/nautical/astronomical twilight angles are 96, 102, and 108 degrees respectively. Prayer time implementations use this to calculate Fajr and Isha.

```dart
final result = getSpa(
  DateTime.utc(2024, 3, 15, 12, 0, 0),
  40.7128, -74.0060, -5.0,
  customAngles: [96.0, 102.0, 108.0],
);

for (final angle in result.angles) {
  print('${angle.zenith}: rise ${angle.sunrise}, set ${angle.sunset}');
}
```

---

[Home](Home)
