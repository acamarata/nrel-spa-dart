/// Types for the NREL SPA algorithm.
library;

/// SPA result from the NREL Solar Position Algorithm.
class SpaResult {
  /// Topocentric zenith angle in degrees.
  final double zenith;

  /// Topocentric azimuth angle, eastward from north, in degrees.
  final double azimuth;

  /// Local sunrise time as fractional hours (NaN if polar).
  final double sunrise;

  /// Local sun transit time (solar noon) as fractional hours.
  final double solarNoon;

  /// Local sunset time as fractional hours (NaN if polar).
  final double sunset;

  /// Custom zenith angle results (one per angle in the input list).
  final List<SpaAnglesResult> angles;

  const SpaResult({
    required this.zenith,
    required this.azimuth,
    required this.sunrise,
    required this.solarNoon,
    required this.sunset,
    this.angles = const [],
  });
}

/// Sunrise/sunset pair for a custom zenith angle.
class SpaAnglesResult {
  final double sunrise;
  final double sunset;

  const SpaAnglesResult({required this.sunrise, required this.sunset});
}
