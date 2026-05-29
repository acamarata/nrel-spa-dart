# Changelog

## [1.0.1] - 2026-05-25

### Added

- `formatTime()` formats fractional hours to `HH:MM:SS` strings; returns `"N/A"` for non-finite or negative values
- `calcSpa()` wraps `getSpa()` and formats sunrise, solarNoon, and sunset as `HH:MM:SS` strings
- `SpaFormattedResult` — typed result for `calcSpa()` with string time fields
- `SpaFormattedAnglesResult` — formatted time strings for custom zenith angle results
- Function code constants exported from the public API: `spaZa`, `spaZaInc`, `spaZaRts`, `spaAll`
- `functionCode` parameter on `getSpa()` — controls calculation mode (ZA only, incidence, RTS, or all)
- `incidence` field on `SpaResult` — surface incidence angle in degrees; `NaN` unless `spaZaInc` or `spaAll` is used

### Changed

- `getSpa()` now defaults `functionCode` to `spaZaRts` (unchanged behaviour for existing callers)
- `SpaResult.sunrise`, `solarNoon`, `sunset` are `NaN` when `functionCode` is `spaZa` or `spaZaInc`, matching the JS reference implementation

## [1.0.0] - 2026-03-08

### Added

- `getSpa()` computes solar position for any date and location
- Custom zenith angle support for twilight calculations
- Full NREL SPA algorithm (Reda & Andreas, 2004)
- Accuracy: ±0.0003° for solar zenith angle
- Valid range: years -2000 to 6000
- Zero external dependencies
