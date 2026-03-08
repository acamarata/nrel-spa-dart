import 'package:nrel_spa/nrel_spa.dart';
import 'package:test/test.dart';

void main() {
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
  });

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
      // Civil (96) sunrise is later than astronomical (108)
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
      // Zenith should differ slightly
      expect((sea.zenith - mountain.zenith).abs(), greaterThan(0));
    });
  });
}
