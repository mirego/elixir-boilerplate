# ElixirBoilerplate

| Section                                               | Description                                                     |
| ----------------------------------------------------- | --------------------------------------------------------------- |
| [🎯 Objectives and context](#-objectives-and-context) | Project introduction and context                                |
| [🚧 Dependencies](#-dependencies)                     | Technical dependencies and how to install them                  |
| [🏎 Kickstart](#kickstart)                             | Details on how to kickstart development on the project          |
| [🏗 Code & architecture](#-code--architecture)         | Details on the application modules and technical specifications |
| [🔭 Possible improvements](#-possible-improvements)   | Possible code refactors, improvements and ideas                 |
| [🚑 Troubleshooting](#-troubleshooting)               | Recurring problems and proven solutions                         |
| [🚀 Deploy](#-deploy)                                 | Deployment details for various enviroments                      |

## 🎯 Objectives and context

…

### Browser support

| Browser | OS  | Constraint |
| ------- | --- | ---------- |
| …       | …   | …          |

## 🚧 Dependencies

Every runtime dependencies are defined in the `.tool-versions` file. These external dependencies are also required:

- PostgreSQL (`~> 12.0`)

## 🏎 Kickstart

### Environment variables

All required environment variables are documented in [`.env.dev`](./.env.dev).

When running `mix` or `make` commands, it is important that these variables are present in the environment. There are several ways to achieve this. Using [`nv`](https://github.com/jcouture/nv) is recommended since it works out of the box with `.env.*` files.

### Initial setup

1. Create both `.env.dev.local` and `.env.test.local` from empty values in [`.env.dev`](./.env.dev) and [`.env.test`](./.env.test)
2. Install Mix and NPM dependencies with `make dependencies`
3. Generate values for mandatory secrets in [`.env.dev`](./.env.dev) with `mix phx.gen.secret`

Then, with variables from `.env.dev` and `.env.dev.local` present in the environment:

4. Create and migrate the database with `mix ecto.setup`
5. Start the Phoenix server with `make run`

### `make` commands

A `Makefile` is present at the root and expose common tasks. The list of these commands is available with `make help`.

### Database

To avoid running PostgreSQL locally on your machine, a `docker-compose.yml` file is included to be able start a PostgreSQL server in a Docker container with `docker-compose up postgresql`.

### Tests

Tests can be ran with `make test` and test coverage can be calculated with `make check-code-coverage`.

### Linting

Several linting and formatting tools can be ran to ensure coding style consistency:

- `make lint-elixir` ensures Elixir code follows our guidelines and best practices
- `make lint-scripts` ensures JavaScript code follows our guidelines and best practices
- `make lint-styles` ensures SCSS code follows our guidelines and best practices
- `make check-format` ensures all code is properly formatted
- `make format` formats files using Prettier and `mix format`

### Continuous integration

The `.github/workflows/ci.yaml` workflow ensures that the codebase is in good shape on each pull request and branch push.

## 🏗 Code & architecture

…

## 🔭 Possible improvements

| Description | Priority | Complexity | Ideas |
| ----------- | -------- | ---------- | ----- |
| …           | …        | …          | …     |

## 🚑 Troubleshooting

### System readiness

The project exposes a `GET /ping` route that sends an HTTP `200 OK` response as soon as the server is ready to accept requests. The response also contains the project version for debugging purpose.

### System health

The project exposes a `GET /health` route that serves the `ElixirBoilerplateHealth` module. This module contains checks to make sure the application and its external dependencies are healthy.

| Name   | Description                  |
| ------ | ---------------------------- |
| `NOOP` | This check is always healthy |

## 🚀 Deploy

### Versions & branches

Each deployment is made from a Git tag. The codebase version is managed with [`incr`](https://github.com/jcouture/incr).

### Container

A Docker image running an _OTP release_ can be created with `make build`, tested with `docker-compose up application` and pushed to a registry with `make push`.
