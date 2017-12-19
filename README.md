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

The application needs the following environment variables:

```
PORT=
CANONICAL_HOST=

# Secret key. You can use `mix phx.gen.secret` to get one or use any secret string you want
SECRET_KEY_BASE=
SESSION_KEY=

# Url of the database
DATABASE_URL=
# Pool size of the DB connections. You may use 20 connections as a starting point.
DATABASE_POOL_SIZE=
```

It also supports these optional environment variables:

```
FORCE_SSL=
BASIC_AUTH_USERNAME=
BASIC_AUTH_PASSWORD=
```

## Linting

All projects using the `phoenix-boilerplate` must include the latest `credo` configuration. 

You will need to add the following file to you project root:
 
 * [mirego-horizontal-web/configurations/credo.exs](https://github.com/mirego/mirego-horizontal-web/blob/master/configurations/credo.exs)

To run it use: `mix credo`
