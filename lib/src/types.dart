/// Types and constants for the NREL SPA algorithm.
library;

// ─── Function code constants ──────────────────────────────────────────────────

/// Compute topocentric zenith and azimuth angles only.
/// Does not compute sunrise, sunset, or solar noon.
const int spaZa = 0;

/// Compute zenith, azimuth, and incidence angle for a tilted surface.
/// Requires [slope] and [azmRotation] in [getSpa] call.
const int spaZaInc = 1;

/// Compute sunrise, sunset, and sun transit (solar noon) in addition to
/// zenith and azimuth. This is the default function code.
const int spaZaRts = 2;

/// Compute all outputs: zenith, azimuth, incidence angle, sunrise, sunset,
/// and sun transit. Combines [spaZaInc] and [spaZaRts].
const int spaAll = 3;

// ─── Result types ─────────────────────────────────────────────────────────────

/// SPA result from the NREL Solar Position Algorithm.
class SpaResult {
  /// Topocentric zenith angle in degrees.
  final double zenith;

  /// Topocentric azimuth angle, eastward from north, in degrees.
  final double azimuth;

  /// Local sunrise time as fractional hours (NaN if polar day/night).
  final double sunrise;

  /// Local sun transit time (solar noon) as fractional hours (NaN if polar).
  final double solarNoon;

  /// Local sunset time as fractional hours (NaN if polar day/night).
  final double sunset;

  /// Surface incidence angle in degrees (populated only for [spaZaInc]/[spaAll]).
  final double incidence;

  /// Custom zenith angle results (one per angle in the input list).
  final List<SpaAnglesResult> angles;

  const SpaResult({
    required this.zenith,
    required this.azimuth,
    required this.sunrise,
    required this.solarNoon,
    required this.sunset,
    this.incidence = double.nan,
    this.angles = const [],
  });
}

/// SPA result with time values formatted as HH:MM:SS strings.
///
/// Created by [calcSpa]. Use [getSpa] for raw fractional-hour values.
class SpaFormattedResult {
  /// Topocentric zenith angle in degrees.
  final double zenith;

  /// Topocentric azimuth angle, eastward from north, in degrees.
  final double azimuth;

  /// Local sunrise time as HH:MM:SS string. "N/A" during polar day/night.
  final String sunrise;

  /// Local sun transit time as HH:MM:SS string. "N/A" during polar day/night.
  final String solarNoon;

  /// Local sunset time as HH:MM:SS string. "N/A" during polar day/night.
  final String sunset;

  /// Surface incidence angle in degrees (populated only for [spaZaInc]/[spaAll]).
  final double incidence;

  /// Custom zenith angle results with formatted times.
  final List<SpaFormattedAnglesResult> angles;

  const SpaFormattedResult({
    required this.zenith,
    required this.azimuth,
    required this.sunrise,
    required this.solarNoon,
    required this.sunset,
    this.incidence = double.nan,
    this.angles = const [],
  });
}

/// Sunrise/sunset pair for a custom zenith angle (raw fractional hours).
class SpaAnglesResult {
  /// Sunrise time for this custom zenith angle as fractional hours (NaN if no
  /// rise/set at this location and time).
  final double sunrise;

  /// Sunset time for this custom zenith angle as fractional hours (NaN if no
  /// rise/set at this location and time).
  final double sunset;

  const SpaAnglesResult({required this.sunrise, required this.sunset});
}

/// Sunrise/sunset pair for a custom zenith angle with formatted time strings.
class SpaFormattedAnglesResult {
  /// Sunrise time for this custom zenith angle as HH:MM:SS.
  /// "N/A" if the sun does not rise/set at this angle.
  final String sunrise;

  /// Sunset time for this custom zenith angle as HH:MM:SS.
  /// "N/A" if the sun does not rise/set at this angle.
  final String sunset;

  const SpaFormattedAnglesResult({required this.sunrise, required this.sunset});
}
