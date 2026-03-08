/// NREL Solar Position Algorithm for Dart.
///
/// Pure Dart implementation of the NREL SPA (Reda & Andreas, 2004).
/// Accurate to ±0.0003° for solar zenith angle over years -2000 to 6000.
/// Zero external dependencies.
library;

export 'src/types.dart';
export 'src/spa.dart' show getSpa;
