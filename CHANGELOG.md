# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Since it is a boilerplate project, there are technically no official (versioned) _releases_. Therefore, the `master` branch should always be stable and usable.

## 2021-03-23

- Generate and expose JS source maps by default (#142)
- Use gzip to serve assets (#143)

## 2021-03-10

- Add `Credo.Check.Readability.StrictModuleLayout` readability check

## 2021-03-03

- Upgrade to Erlang `23.2`
- Upgrade mix dependencies
- Upgrage NPM dependencies to the latest compatible versions of Webpack 4
- Change configuration files to adopt the \*.config.js standard

## 2020-11-25

- Upgrage to Elixir `1.11` and NodeJS `14.15`

## 2020-11-13

- Revert the removal of `PORT` environment variable (#133)

## 2020-11-12

Simplification of the Router URLs configuration (#132)

Router's Endpoint config now requires only a CANONICAL_URL and a STATIC_URL from which it extrapolates the different URI components such as `scheme`, `host` and `port`.

Environment variables changes:

_Added_

- `CANONICAL_URL=`
- `STATIC_URL=`

_Removed_

- `PORT=`
- `FORCE_SSL=`
- `STATIC_URL_SCHEME=`
- `STATIC_URL_HOST=`
- `STATIC_URL_PORT=`

## 2020-11-04

- Move `Plug.SSL` plug initialization to endpoint module attribute (#130)

## 2020-10-08

- Upgrage to Erlang `23.1.1` and Alpine `1.12.0`
- Upgrade to Phoenix `1.5`
- Upgrade to Ecto `3.5`
- Upgrade to Absinthe `1.5`

### New Relic instrumentation for Phoenix

The `instrumenters` configuration was deprecated from `Phoenix.Endpoint`, and there is no update in [`new_relix_phoenix`](https://hex.pm/packages/new_relic_phoenix) yet to reflect this change! The instrumenter might not work properly…

> [warn] :instrumenters configuration for ElixirBoilerplateWeb.Endpoint is deprecated and has no effect

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
