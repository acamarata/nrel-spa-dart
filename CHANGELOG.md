## 1.2.0

### Added
- **`getSpa` and `calcSpa` accept a `'YYYY-MM-DD'` string as well as a `DateTime`,** with `toSpaInstant` exported.

  The two functions answer two different kinds of question from one argument, and they do not want the same input. Instantaneous position (`zenith`, `azimuth`, `incidence`) depends on the exact moment, and a `DateTime` is exactly right. Rise, transit and set depend only on the calendar **day** — verified: holding the date and varying the hour from 00 to 23 leaves `sunrise`, `solarNoon` and `sunset` identical to six decimal places.

  For that second case a bare `DateTime` was a trap. `toUtc()` deliberately discards the author's frame in favour of the instant, which is right for position and wrong for a day: `DateTime(2026, 8, 22)` is `2026-08-21T15:00Z` in Tokyo, so a Tokyo caller silently received the previous day's sunrise. Measured at 59 seconds out for New York (5.205775 against 5.222164 hours).

  A `'YYYY-MM-DD'` string names the day outright, anchored at UTC noon — the furthest point from either day boundary. It returns the identical value on every host, and matches the TypeScript `nrel-spa` 2.2.0 output exactly, which a test now asserts.

### Changed
- Nothing on the `DateTime` path; it behaves exactly as in 1.1.0. A test guards that instantaneous position still varies with the hour, so a future change cannot normalise the instant away.

### Notes on upgrading
Purely additive. If you use this package to ask about a **day** rather than a moment, prefer the string form:

```dart
getSpa('2026-08-22', lat, lng, tz);        // unambiguous
getSpa(DateTime(2026, 8, 22), lat, lng, tz); // depends on where the machine is
```

Verified downstream: `pray_calc_dart` 1.2.0's full suite, including its 282-vector cross-language parity fixture, passes unchanged against this release.

## 1.1.0

- **The NREL "no such event" sentinel no longer crosses the public API.** The reference
  implementation writes `-99999` into `srha`, `ssha`, `sta`, `suntransit`, `sunrise` and
  `sunset` when the sun does not cross the horizon, and that value was handed to callers
  unchanged. Because it is a *finite* number it passed every `isFinite` guard downstream
  and rendered as a real clock time. `getSpa` now returns `double.nan` for events that do
  not occur. Two leak paths closed: the raw result fields, and `_adjustForCustomAngle`,
  which offsets from solar transit and so produced plausible-looking values such as
  `-100001.38`.
- **`solarNoon` survives polar day and polar night.** The sun crosses the local meridian
  every day everywhere on Earth, so solar transit is always defined, but the reference
  blanks it alongside the genuinely absent sunrise and sunset. It is now recovered from
  the equation of time. Where the reference produces a transit that value passes through
  untouched, so no existing result moves.
- `lib/src/spa.dart` remains a faithful port of the reference, sentinel included; the
  conversion happens at the API boundary.

# Changelog

## [1.0.1] - 2026-05-25

### Added
- Initial public release: NREL Solar Position Algorithm (SPA) port to Dart
- Exports: `calcSpa`, `formatTime`, `SpaFormattedResult`, `SpaFormattedAnglesResult`
- Exports: `spaZa`, `spaZaInc`, `spaZaRts`, `spaAll`
- 48 tests passing
- Pure Dart implementation
