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

# OTP Release

This boilerplate include a basic OTP/Docker setup with automated Ecto migration support.

## Build

The docker command beautifully wrapped in a [Makefile](./Makefile), so to build a Docker image, locally or in a
Jenkins job, simply use the `build` task.

```shell
> make Build
Sending build context to Docker daemon  418.3kB
Step 1/26 : ARG ALPINE_VERSION=3.8
Step 2/26 : FROM elixir:1.7.3-alpine AS builder
...
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

## Run

A `docker-compose.yml` file is available in [infra/docker](./infra/docker) to run the boilerplate project
with a vanilla Postgres instance/service.

```shell
> cd infra/docker
> docker-compose up -d postgres
Creating network "docker_default" with the default driver
Creating docker_postgres_1 ... done
> docker-compose up api
docker_postgres_1 is up-to-date
Recreating docker_api_1 ... done
Attaching to docker_api_1
```


You may also use the `Make` tasks for an even simpler setup.

```shell
> make start
docker-compose --file 'infra/docker/docker-compose.yml' up --detach postgres
phoenix_boilerplate-postgres is up-to-date
docker-compose --file 'infra/docker/docker-compose.yml' up api
phoenix_boilerplate-postgres is up-to-date
phoenix_boilerplate-api is up-to-date
Attaching to phoenix_boilerplate-api
phoenix_boilerplate-api | Starting dependencies..
phoenix_boilerplate-api | Starting repos..
phoenix_boilerplate-api | Running migrations for phoenix_boilerplate
phoenix_boilerplate-api | Success!
phoenix_boilerplate-api | 02:35:22.931 [info] Already up
phoenix_boilerplate-api | 02:35:24.554 [info] Running PhoenixBoilerplateWeb.Endpoint with Cowboy using http://0.0.0.0:4000
```
