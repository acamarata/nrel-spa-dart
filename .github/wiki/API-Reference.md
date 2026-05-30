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
  double deltaUt1 = 0,
  double deltaT = 67,
  double slope = 0,
  double azmRotation = 0,
  double atmosRefract = 0.5667,
  int functionCode = spaZaRts,
  List<double> customAngles = const [],
})
```

Computes solar position for a given location and moment. Returns raw fractional-hour values.

Throws `ArgumentError` if any input falls outside the NREL SPA valid range.

### Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `date` | `DateTime` | required | UTC date and time |
| `latitude` | `double` | required | Degrees (-90 to 90, south negative) |
| `longitude` | `double` | required | Degrees (-180 to 180, west negative) |
| `timezone` | `double` | required | Hours from UTC (e.g., -5 for EST) |
| `elevation` | `double` | 0 | Meters above sea level |
| `pressure` | `double` | 1013 | Atmospheric pressure (mbar) |
| `temperature` | `double` | 15 | Temperature (Celsius) |
| `deltaUt1` | `double` | 0 | Difference UT1 - UTC (seconds, typically small) |
| `deltaT` | `double` | 67 | TT - UT1 (seconds) |
| `slope` | `double` | 0 | Surface tilt angle (degrees, for incidence) |
| `azmRotation` | `double` | 0 | Surface azimuth rotation (degrees, for incidence) |
| `atmosRefract` | `double` | 0.5667 | Atmospheric refraction at horizon (degrees) |
| `functionCode` | `int` | `spaZaRts` | What to calculate; one of `spaZa`, `spaZaInc`, `spaZaRts`, `spaAll` |
| `customAngles` | `List<double>` | `[]` | Zenith angles for custom rise/set computation |

### Function codes

| Constant | Value | Computes |
| --- | --- | --- |
| `spaZa` | 0 | Zenith and azimuth only |
| `spaZaInc` | 1 | Zenith, azimuth, and surface incidence |
| `spaZaRts` | 2 | Zenith, azimuth, sunrise, sunset, solar noon (default) |
| `spaAll` | 3 | All of the above |

### SpaResult fields

| Field | Type | Description |
| --- | --- | --- |
| `zenith` | `double` | Solar zenith angle (degrees) |
| `azimuth` | `double` | Solar azimuth angle, eastward from north (degrees) |
| `sunrise` | `double` | Sunrise in fractional hours, local time (NaN if polar) |
| `solarNoon` | `double` | Solar noon in fractional hours, local time (NaN if polar) |
| `sunset` | `double` | Sunset in fractional hours, local time (NaN if polar) |
| `incidence` | `double` | Surface incidence angle (degrees; `spaZaInc`/`spaAll` only) |
| `angles` | `List<SpaAnglesResult>` | Rise/set pairs for each entry in `customAngles` |

### SpaAnglesResult fields

| Field | Type | Description |
| --- | --- | --- |
| `sunrise` | `double` | Rise time in fractional hours for this zenith angle |
| `sunset` | `double` | Set time in fractional hours for this zenith angle |

---

## calcSpa

```dart
SpaFormattedResult calcSpa(
  DateTime date,
  double latitude,
  double longitude,
  double timezone, {
  // same optional parameters as getSpa
})
```

Same as `getSpa`, but formats `sunrise`, `solarNoon`, and `sunset` as `HH:MM:SS` strings. Returns `"N/A"` for those fields during polar day or polar night.

### SpaFormattedResult fields

| Field | Type | Description |
| --- | --- | --- |
| `zenith` | `double` | Solar zenith angle (degrees) |
| `azimuth` | `double` | Solar azimuth angle (degrees) |
| `sunrise` | `String` | Sunrise as `HH:MM:SS`, or `"N/A"` |
| `solarNoon` | `String` | Solar noon as `HH:MM:SS`, or `"N/A"` |
| `sunset` | `String` | Sunset as `HH:MM:SS`, or `"N/A"` |
| `incidence` | `double` | Surface incidence angle (degrees) |
| `angles` | `List<SpaFormattedAnglesResult>` | Rise/set pairs with formatted strings |

---

## formatTime

```dart
String formatTime(double hours)
```

Formats fractional hours to an `HH:MM:SS` string. Returns `"N/A"` for non-finite or negative values (polar scenarios).

---

## Custom zenith angles

Pass any solar zenith angles to `customAngles` to get rise/set times at those depression depths. Standard angles: civil twilight = 96°, nautical = 102°, astronomical = 108°. Prayer time implementations use this for Fajr and Isha.

```dart
final result = getSpa(
  DateTime.utc(2024, 3, 15, 12, 0, 0),
  40.7128, -74.0060, -5.0,
  customAngles: [96.0, 102.0, 108.0],
);

for (int i = 0; i < result.angles.length; i++) {
  print('Angle ${i}: rise ${result.angles[i].sunrise}, set ${result.angles[i].sunset}');
}
```

---

[Home](Home)
