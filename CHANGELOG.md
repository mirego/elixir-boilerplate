# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Since it is a boilerplate project, there are technically no official (versioned) _releases_. Therefore, the `master` branch should always be stable and usable.

## 2020-06-17

- Add MixAudit vulnerability security scanning (#114)

## 2020-05-27

- Do not provide `static_url` configuration to Phoenix endpoint if `STATIC_URL_HOST` isn’t present (#110)

## 2020-05-15

- Do not raise “missing `_test` suffix” error when DATABASE_URL is not present
- Refactor router split to avoid “You have instrumented twice in the same plug” New Relic warning (#108)

## 2020-03-26

### Fixed

- `make` targets using `npx` now work properly since we now change the current working directory to `assets` before running them
- The `boilerplate-setup.sh` script now supports PascalCase name with consecutive uppercase letters (eg. `FooBarBBQ` → `foo_bar_bbq`)
- The `boilerplate-setup.sh` script now takes into account deeper hierarchy files and the Github Action CI workflow file
- The `BOILERPLATE_README.fr.md` and `BOILERPLATE_README.md` now list the correct dependencies

### Added

- Added a local database URL check for the test configuration which prevents tests from being run on an external database

## 2020-03-18

### Fixed

- Makefile (`Makefile`) output of the different targets when using numbers

## 2020-01-22

### Updated

- Improve Docker-related environment variables in Makefile (#86)

## 2019-12-19

### Added

- Improved healthcheck setup with `plug_checkup` (#84)

### Updated

- Upgrade from `alpine:3.9` to `alpine:3.10` as base Docker image

## 2019-10-18

### Added

- Project changelog (`CHANGELOG.md`)
