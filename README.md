# PhoenixBoilerplate

## The first step

1. Clone this project.
2. Remove the `.git` folder with `rm -rf .git`.
3. Run the `./project-renamer.sh YourProjectName` script to remove every references to `PhoenixBoilerplate`.
4. Delete the renamer script.
5. Update the `README`.
6. Create the new repository and commit as usual.

_Voila!_

## Executing mix commands

Because the app is modeled with the Twelve-Factor app architecture, all configs are stored in the environment.

When executing mix command, you should always make sure that the required system env are present. You can
use `source`, [nv](https://github.com/jcouture/nv) or a custom l33t bash script.

Every following steps assume you have this kind of system.

## Running the app

  1. Create your .env and .env.test config file.
  2. Install dependencies with `mix deps.get`.
  3. Create and migrate your database with `mix ecto.setup`
  4. Start Phoenix endpoint with `mix phx.server`

## Environment variables

All environment variables needed (or supported) to run this application are listed in [`.env.dev`](./.env.dev).

## Linting

You will need to add these files to you project root:

* `.svgo.yml`

Their latest version can be found [here](https://github.com/mirego/mirego-horizontal-web/blob/master/configurations).

The linting/testing script can be ran with `./priv/scripts/ci-check.sh`.

# Makefile targets!

Usefull commands to run services are wrapped in a [Makefile](./Makefile)!

```shell
> make
phoenix_boilerplate:0.0.1 → phoenix_boilerplate:'latest'
build                          Build the OTP Docker image
postgres                       Start a local Postgres instance inside of a docker-compose environment
run_release                    Run the OTP release locally inside of a docker-compose environment
stop                           Stop every services of in the docker-compose environment
```

## Development

For development purposes, a `docker-compose` setup is available in [infra/docker](./infra/docker). To start the a Postgres instance locally:

```shell
> make postgres
docker-compose --file 'infra/docker/docker-compose.yml' up --detach postgres
Creating network "docker_default" with the default driver
Creating phoenix_boilerplate-postgres ... done
```

The instance is automatically bound to the host port `5432` so you may use it as a _baremetal_ installation.

## OTP Release

This boilerplate include a basic OTP/Docker setup with automated Ecto migration support. To build a Docker image, locally or in a Jenkins job, use the `build` target.

```shell
> make build
Sending build context to Docker daemon  418.3kB
Step 1/26 : ARG ALPINE_VERSION=3.8
Step 2/26 : FROM elixir:1.7.3-alpine AS builder
…
Step 25/26 : ENTRYPOINT ["docker-entrypoint.sh"]
 ---> Using cache
 ---> dbc449799819
Step 26/26 : CMD ["foreground"]
 ---> Using cache
 ---> 3a746cec33fa
Successfully built 3a746cec33fa
Successfully tagged phoenix_boilerplate:latest
```

That’s it, you now have a distributable OTP release!

## Test the OTP release

To run the docker image with a vanilla Postgres instance in a single command, run the `run_release` target:

```shell
> make run_release
docker build \
…
Successfully built 0a14e9bc8c32
Successfully tagged phoenix_boilerplate:latest
docker-compose --file 'infra/docker/docker-compose.yml' up api
phoenix_boilerplate-postgres is up-to-date
phoenix_boilerplate-api is up-to-date
Attaching to phoenix_boilerplate-api
phoenix_boilerplate-api | Starting dependencies…
phoenix_boilerplate-api | Starting repos…
phoenix_boilerplate-api | Running migrations for phoenix_boilerplate
phoenix_boilerplate-api | Success!
phoenix_boilerplate-api | 19:55:19.515 [info] Already up
phoenix_boilerplate-api | 19:55:21.139 [info] Running PhoenixBoilerplateWeb.Endpoint with Cowboy using http://0.0.0.0:4000
```
