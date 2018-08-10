# PhoenixBoilerplate

## The first step

Use the included `./project-renamer.sh YourProjectName` to remove all reference from `PhoenixBoilerplate` in your app.
When this is done, you should remove this part from the file, update the title and delete the script ;)

## Executing mix commands

Because the app is modeled with the Twelve-Factor app architecture, all configs are stored in the environment.

When executing mix command, you should always make sure that the required system env are present.
You can use `source`, [nv](https://github.com/jcouture/nv) or a custom l33t bash script.

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
