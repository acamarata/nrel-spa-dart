import 'dart:math';

import 'package:nrel_spa/nrel_spa.dart';
import 'package:test/test.dart';

void main() {
  // ─── formatTime ─────────────────────────────────────────────────────────────

  group('formatTime', () {
    test('formats basic time correctly', () {
      expect(formatTime(12.5), equals('12:30:00'));
      expect(formatTime(0.0), equals('00:00:00'));
      expect(formatTime(23.9997), equals('23:59:59'));
    });

    test('returns N/A for non-finite values', () {
      expect(formatTime(double.nan), equals('N/A'));
      expect(formatTime(double.infinity), equals('N/A'));
      expect(formatTime(double.negativeInfinity), equals('N/A'));
    });

    test('returns N/A for negative values', () {
      expect(formatTime(-1.0), equals('N/A'));
      expect(formatTime(-0.001), equals('N/A'));
    });

    test('wraps at 24h boundary', () {
      // 24.0 hours should wrap to 00:00:00
      expect(formatTime(24.0), equals('00:00:00'));
    });

    test('pads hours, minutes, seconds with leading zeros', () {
      expect(formatTime(6.0 + 5.0 / 60 + 3.0 / 3600), equals('06:05:03'));
    });
  });

  // ─── function code constants ─────────────────────────────────────────────────

  group('function code constants', () {
    test('spaZa = 0', () => expect(spaZa, equals(0)));
    test('spaZaInc = 1', () => expect(spaZaInc, equals(1)));
    test('spaZaRts = 2', () => expect(spaZaRts, equals(2)));
    test('spaAll = 3', () => expect(spaAll, equals(3)));
  });

  // ─── getSpa — basic functionality ───────────────────────────────────────────

  group('getSpa — basic functionality', () {
    test('returns valid zenith and azimuth', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result.zenith, inInclusiveRange(0.0, 180.0));
      expect(result.azimuth, inInclusiveRange(0.0, 360.0));
    });

    test('sunrise is before sunset', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result.sunrise, lessThan(result.sunset));
    });

    test('solar noon is between sunrise and sunset', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result.solarNoon, greaterThan(result.sunrise));
      expect(result.solarNoon, lessThan(result.sunset));
    });

    test('incidence is NaN for default spaZaRts', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result.incidence.isNaN, isTrue);
    });
  });

  // ─── getSpa — spaZa function code ───────────────────────────────────────────

  group('getSpa — spaZa (zenith+azimuth only)', () {
    test('zenith and azimuth are valid', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZa,
      );
      expect(result.zenith, inInclusiveRange(0.0, 180.0));
      expect(result.azimuth, inInclusiveRange(0.0, 360.0));
    });

    test('sunrise, solarNoon, sunset are NaN', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZa,
      );
      expect(result.sunrise.isNaN, isTrue);
      expect(result.solarNoon.isNaN, isTrue);
      expect(result.sunset.isNaN, isTrue);
    });

    test('incidence is NaN for spaZa', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZa,
      );
      expect(result.incidence.isNaN, isTrue);
    });

    test('matches spaZaRts zenith/azimuth to within floating point tolerance',
        () {
      final za = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZa,
      );
      final rts = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect((za.zenith - rts.zenith).abs(), lessThan(1e-10));
      expect((za.azimuth - rts.azimuth).abs(), lessThan(1e-10));
    });

    test('throws when customAngles used with spaZa', () {
      expect(
        () => getSpa(
          DateTime.utc(2024, 3, 15, 12, 0, 0),
          40.7128,
          -74.0060,
          -5.0,
          functionCode: spaZa,
          customAngles: [96.0],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ─── getSpa — spaZaInc function code ────────────────────────────────────────

  group('getSpa — spaZaInc (surface incidence)', () {
    test('incidence angle is populated', () {
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZaInc,
        slope: 30.0,
        azmRotation: 180.0,
      );
      expect(result.incidence, inInclusiveRange(0.0, 180.0));
    });

    test('sunrise, solarNoon, sunset are NaN', () {
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZaInc,
        slope: 30.0,
        azmRotation: 180.0,
      );
      expect(result.sunrise.isNaN, isTrue);
      expect(result.solarNoon.isNaN, isTrue);
      expect(result.sunset.isNaN, isTrue);
    });

    test('flat surface incidence equals zenith', () {
      // slope=0, azmRotation=0: incidence should equal zenith
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZaInc,
        slope: 0.0,
        azmRotation: 0.0,
      );
      expect((result.incidence - result.zenith).abs(), lessThan(1e-6));
    });
  });

  // ─── getSpa — spaAll function code ──────────────────────────────────────────

  group('getSpa — spaAll (zenith+azimuth+incidence+RTS)', () {
    test('incidence, sunrise, solarNoon, sunset all populated', () {
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaAll,
        slope: 30.0,
        azmRotation: 180.0,
      );
      expect(result.incidence, inInclusiveRange(0.0, 180.0));
      expect(result.sunrise, greaterThan(0.0));
      expect(result.solarNoon, greaterThan(0.0));
      expect(result.sunset, greaterThan(0.0));
    });

    test('spaAll matches spaZaRts RTS fields', () {
      final all = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaAll,
        slope: 30.0,
        azmRotation: 180.0,
      );
      final rts = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect((all.sunrise - rts.sunrise).abs(), lessThan(1e-6));
      expect((all.sunset - rts.sunset).abs(), lessThan(1e-6));
      expect((all.solarNoon - rts.solarNoon).abs(), lessThan(1e-6));
    });

    test('throws when customAngles used with spaZaInc', () {
      expect(
        () => getSpa(
          DateTime.utc(2024, 3, 15, 12, 0, 0),
          40.7128,
          -74.0060,
          -5.0,
          functionCode: spaZaInc,
          customAngles: [96.0],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ─── getSpa — custom angles ──────────────────────────────────────────────────

  group('getSpa — custom angles', () {
    test('civil and astronomical twilight pairs', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        customAngles: [96.0, 108.0],
      );
      expect(result.angles.length, equals(2));
      // Civil (96°) sunrise is later than astronomical (108°)
      expect(result.angles[0].sunrise, greaterThan(result.angles[1].sunrise));
      // Civil sunset is earlier than astronomical
      expect(result.angles[0].sunset, lessThan(result.angles[1].sunset));
    });

    test('nautical twilight (102)', () {
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        customAngles: [102.0],
      );
      expect(result.angles.length, equals(1));
      expect(result.angles[0].sunrise, lessThan(result.sunrise));
      expect(result.angles[0].sunset, greaterThan(result.sunset));
    });
  });

  // ─── getSpa — locations ──────────────────────────────────────────────────────

  group('getSpa — locations', () {
    test('Mecca summer solstice', () {
      final result = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        21.3891,
        39.8579,
        3.0,
      );
      expect(result.zenith, inInclusiveRange(0.0, 90.0));
      expect(result.sunrise, greaterThan(0));
      expect(result.sunset, greaterThan(0));
    });

    test('London winter solstice', () {
      final result = getSpa(
        DateTime.utc(2024, 12, 21, 12, 0, 0),
        51.5074,
        -0.1278,
        0.0,
      );
      expect(result.zenith, greaterThan(60.0)); // Sun is low
      expect(result.sunrise, greaterThan(7.0)); // Late sunrise
    });

    test('equator at equinox — zenith near 0 at noon', () {
      final result = getSpa(DateTime.utc(2024, 3, 20, 12, 0, 0), 0.0, 0.0, 0.0);
      expect(result.zenith, lessThan(10.0));
    });

    test('Sydney summer (December)', () {
      final result = getSpa(
        DateTime.utc(2024, 12, 21, 3, 0, 0),
        -33.8688,
        151.2093,
        11.0,
      );
      expect(result.sunrise, greaterThan(0));
      expect(result.sunset, greaterThan(0));
    });
  });

  // ─── getSpa — edge cases ─────────────────────────────────────────────────────

  group('getSpa — edge cases', () {
    test('throws for invalid input (latitude > 90)', () {
      expect(
        () => getSpa(DateTime.utc(2024, 1, 1), 91.0, 0.0, 0.0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('handles elevation parameter', () {
      final sea = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      final mountain = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        elevation: 3000,
      );
      // Zenith should differ slightly due to parallax correction
      expect((sea.zenith - mountain.zenith).abs(), greaterThan(0));
    });

    test('throws for invalid functionCode', () {
      expect(
        () => getSpa(DateTime.utc(2024, 1, 1), 40.0, -74.0, -5.0,
            functionCode: 4),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ─── calcSpa ─────────────────────────────────────────────────────────────────

  group('calcSpa', () {
    test('returns SpaFormattedResult with string times', () {
      final result = calcSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result, isA<SpaFormattedResult>());
      expect(result.sunrise, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
      expect(result.solarNoon, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
      expect(result.sunset, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
    });

    test('zenith and azimuth match getSpa', () {
      final dt = DateTime.utc(2024, 3, 15, 12, 0, 0);
      final raw = getSpa(dt, 40.7128, -74.0060, -5.0);
      final fmt = calcSpa(dt, 40.7128, -74.0060, -5.0);
      expect(fmt.zenith, closeTo(raw.zenith, 1e-10));
      expect(fmt.azimuth, closeTo(raw.azimuth, 1e-10));
    });

    test('spaZa returns N/A for time fields', () {
      final result = calcSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaZa,
      );
      expect(result.sunrise, equals('N/A'));
      expect(result.solarNoon, equals('N/A'));
      expect(result.sunset, equals('N/A'));
    });

    test('formats custom angles as HH:MM:SS', () {
      final result = calcSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        customAngles: [96.0],
      );
      expect(result.angles.length, equals(1));
      expect(result.angles[0], isA<SpaFormattedAnglesResult>());
      expect(
        result.angles[0].sunrise,
        matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')),
      );
    });

    test('incidence populated for spaAll', () {
      final result = calcSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        functionCode: spaAll,
        slope: 30.0,
        azmRotation: 180.0,
      );
      expect(result.incidence, inInclusiveRange(0.0, 180.0));
    });
  });

  // ─── Numerical cross-validation against JS reference ────────────────────────
  // Reference values computed from nrel-spa JS package (spa.js v2.0.1)
  // for the NREL SPA example date: 2003-10-17 12:30:30 UTC, Golden CO.
  // JS call: getSpa(new Date('2003-10-17T12:30:30Z'), 39.742476, -105.1786,
  //            -7.0, {elevation:1830.14, pressure:820, temperature:11,
  //                   deltaT:67, deltaUt1:0})
  // Expected: zenith=50.0°±0.5°, azimuth=194.0°±1.0°
  // Sunrise ≈ 06:12, Sunset ≈ 17:20 (local time, -7h)

  group('numerical cross-validation — NREL SPA reference date', () {
    late SpaResult ref;

    setUp(() {
      ref = getSpa(
        DateTime.utc(2003, 10, 17, 12, 30, 30),
        39.742476, // Golden CO
        -105.1786,
        -7.0,
        elevation: 1830.14,
        pressure: 820,
        temperature: 11,
        deltaT: 67,
        deltaUt1: 0,
      );
    });

    test('zenith within 0.5° of expected ~50.1°', () {
      expect(ref.zenith, closeTo(50.1, 0.5));
    });

    test('azimuth within 1.0° of expected ~194°', () {
      expect(ref.azimuth, closeTo(194.0, 1.0));
    });

    test('sunrise in range 5.5–7.0h local', () {
      expect(ref.sunrise, inInclusiveRange(5.5, 7.0));
    });

    test('sunset in range 16.5–18.0h local', () {
      expect(ref.sunset, inInclusiveRange(16.5, 18.0));
    });

    test('solar noon in range 11.5–13.5h local', () {
      expect(ref.solarNoon, inInclusiveRange(11.5, 13.5));
    });
  });

  // ─── Numerical cross-validation — incidence angle ───────────────────────────
  // JS: getSpa(new Date('2003-10-17T12:30:30Z'), 39.742476, -105.1786, -7,
  //       {elevation:1830.14, pressure:820, temperature:11, slope:30,
  //        azmRotation:-10, function:1})
  // Expected incidence ≈ 25°±5°

  group('numerical cross-validation — incidence angle', () {
    test('surface incidence for tilted panel ≈ 25° (±5°)', () {
      final result = getSpa(
        DateTime.utc(2003, 10, 17, 12, 30, 30),
        39.742476,
        -105.1786,
        -7.0,
        elevation: 1830.14,
        pressure: 820,
        temperature: 11,
        deltaT: 67,
        deltaUt1: 0,
        functionCode: spaZaInc,
        slope: 30.0,
        azmRotation: -10.0,
      );
      expect(result.incidence, inInclusiveRange(20.0, 30.0));
    });
  });

  // ─── Numerical cross-validation — formatTime round-trip ──────────────────────

  group('formatTime — round-trip with getSpa', () {
    test('formatted sunrise parses back to within 1 second', () {
      final raw = getSpa(
        DateTime.utc(2024, 6, 21, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      final str = formatTime(raw.sunrise);
      final parts = str.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final s = int.parse(parts[2]);
      final decoded = h + m / 60.0 + s / 3600.0;
      expect((decoded - raw.sunrise).abs(), lessThan(1 / 3600.0 + 1e-9));
    });
  });

  // ─── Type checks ─────────────────────────────────────────────────────────────

  group('type checks', () {
    test('SpaResult angles default to empty list', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
      );
      expect(result.angles, isEmpty);
    });

    test('SpaAnglesResult has sunrise and sunset', () {
      final result = getSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        customAngles: [96.0],
      );
      expect(result.angles[0].sunrise, isA<double>());
      expect(result.angles[0].sunset, isA<double>());
    });

    test('SpaFormattedAnglesResult has string sunrise and sunset', () {
      final result = calcSpa(
        DateTime.utc(2024, 3, 15, 12, 0, 0),
        40.7128,
        -74.0060,
        -5.0,
        customAngles: [96.0],
      );
      expect(result.angles[0].sunrise, isA<String>());
      expect(result.angles[0].sunset, isA<String>());
    });
  });
}
