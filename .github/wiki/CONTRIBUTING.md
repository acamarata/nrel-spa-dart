# Contributing to nrel-spa-dart

Thanks for taking the time to contribute.

## Getting started

1. Fork the repository and clone your fork.
2. Install the Dart SDK (stable channel): [dart.dev/get-dart](https://dart.dev/get-dart)
3. Install dependencies: `dart pub get`
4. Run the tests: `dart test`

## Reporting bugs

Open a GitHub issue with:
- A minimal reproducible example
- The actual output and the expected output
- Your Dart SDK version (`dart --version`)
- Your operating system

## Suggesting enhancements

Open a GitHub issue before writing code. Describe the use case and the proposed API. Algorithm changes require a reference to the relevant paper or standard.

## Pull requests

1. Create a feature branch from `main`.
2. Keep changes focused. One feature or bug fix per PR.
3. Add or update tests for any changed behavior.
4. Run `dart analyze` and confirm zero issues.
5. Run `dart format lib/ test/` before committing.
6. Update the CHANGELOG.md under `## [Unreleased]` with a brief description.
7. Open the PR with a clear title and description.

## Code style

Follow standard Dart conventions. The project uses `dart format` with default settings. Lint rules are defined in `analysis_options.yaml` and inherit from the `lints` package.

Comments should explain *why*, not *what*. Algorithm steps should reference the equation number from Reda & Andreas (2004).

## Algorithm changes

This package implements the NREL Solar Position Algorithm exactly as specified in NREL/TP-560-34302. Proposed deviations from the paper require strong justification and a test against the validation dataset from the paper.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
