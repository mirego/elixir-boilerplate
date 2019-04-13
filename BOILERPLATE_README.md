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

- Node.js (`~> 10.14`)
- NPM (`~> 6.4`)
- Elixir (`~> 1.8`)
- Erlang (`~> 21.3`)
- PostgreSQL (`~> 10.0`)

## 🏎 Kickstart

### Environment variables

All required environment variables are documented in [`.env.dev`](./.env.dev).

When running `mix` or `make` commands, it is important that these variables are present in the environment. You can use `source`, [`nv`](https://github.com/jcouture/nv) or any custom script to achieve this.

### Initial setup

1. Create both `.env.dev.local` and `.env.test.local` from empty values in [`.env.dev`](./.env.dev) and [`.env.test`](./.env.test)
2. Install Mix and NPM dependencies with `make dependencies`
3. Create and migrate the database with `mix ecto.setup`
4. Compile the application with `make compile`
5. Start the Phoenix server with `iex -S mix phx.server` with environment variables from `.env.dev` and `.env.dev.local`

### `make` commands

A `Makefile` is present at the root and expose common tasks. The list of these commands is available with `make help`.

### Database

To avoid running PostgreSQL locally on your machine, a `docker-compose.yml` file is included to be able start a PostgreSQL server in a Docker container with `make dev-start-postgresql`.

### Tests

Tests can be ran with `make test` and test coverage can be calculated with `make test-coverage`.

### Linting

Several linting and formatting tools can be ran to ensure coding style consistency:

- `make lint-format` ensures Elixir code is properly formatted
- `make lint-credo` ensures Elixir code follows our best practices
- `make lint-compile` ensures Elixir code compilation does not raise any warning
- `make lint-eslint` ensures JavaScript code follows our best practices
- `make lint-stylelint` ensures SCSS code follows our best practices
- `make lint-prettier` ensures JavaScript, SCSS and GraphQL code is properly formatted

All of these commands can be executed at the same time with the helpful `make lint` command.

### Continuous integration

The `priv/scripts/ci-check.sh` script runs a set of commands (tests, linting, etc.) to make sure the project and its code are in a good state.

## 🏗 Code & architecture

…

## 🔭 Possible improvements

| Description | Priority | Complexity | Ideas |
| ----------- | -------- | ---------- | ----- |
| …           | …        | …          | …     |

## 🚑 Troubleshooting

…

## 🚀 Deploy

### Versions & branches

Each deployment is made from a Git tag. The codebase version is managed with [`incr`](https://github.com/jcouture/incr).

### Container

A new _OTP release_ running in a Docker container can be created with `make build`, tested with `make dev-start-application` and pushed to a registry with `make push`.
