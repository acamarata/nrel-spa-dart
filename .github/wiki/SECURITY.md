# Security

## Scope

`nrel_spa` is a pure-computation library with no network access, no file I/O, and no external dependencies. The attack surface is limited to the mathematical functions themselves.

The main concern is input validation: `getSpa` and `calcSpa` throw `ArgumentError` when inputs fall outside the NREL SPA valid ranges (e.g., latitude outside -90..90, year outside -2000..6000). If you pass untrusted input to these functions, catch the error.

## Reporting a Vulnerability

If you discover a security issue (for example, a case where malformed input causes unexpected behavior beyond the documented `ArgumentError`), please report it privately before filing a public issue.

**Contact:** alisalaah@gmail.com

Include:

1. A description of the vulnerability
2. Steps to reproduce it
3. The version of `nrel_spa` where you observed the issue
4. Any suggested fix if you have one

You can expect an acknowledgment within 48 hours and a resolution or status update within 7 days.

## Known Limitations

- The algorithm is valid for years -2000 to 6000 and is accurate to within ±0.0003° for solar zenith angle. Inputs outside this range produce `ArgumentError`.
- This is a Dart port of the NREL SPA algorithm (Reda & Andreas, 2004, NREL/TP-560-34302). Numerical results match the reference implementation to the precision defined in that report.
