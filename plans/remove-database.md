# Plan: Remove Database / Ecto

> Use case: API gateway only (no database)

## Phase 1: Delete database modules & files

### 1.1 - Delete Ecto modules

```bash
rm lib/elixir_boilerplate/repo.ex
rm lib/elixir_boilerplate/schema.ex
rm lib/elixir_boilerplate/release.ex
```

Files removed:

- `repo.ex` - `ElixirBoilerplate.Repo` (Ecto.Repo with Postgres adapter)
- `schema.ex` - `ElixirBoilerplate.Schema` macro (Ecto.Schema setup, binary_id, timestamps)
- `release.ex` - `ElixirBoilerplate.Release` (migrate/rollback via Ecto.Migrator)

### 1.2 - Delete migration overlay script

```bash
rm rel/overlays/bin/migrate
```

### 1.3 - Delete priv/repo directory

```bash
rm -rf priv/repo
```

Files removed:

- `priv/repo/migrations/.gitkeep`
- `priv/repo/migrations/1696952524_add_telemetry_ui_events_table.exs`
- `priv/repo/seeds.exs`
- `priv/repo/dummy.exs`

### 1.4 - Delete test DataCase

```bash
rm test/support/data_case.ex
```

---

## Phase 2: Remove dependencies from `mix.exs`

### 2.1 - Remove database deps (4 lines + comments)

```diff
-      # Database
-      {:ecto_sql, "~> 3.10"},
-      {:postgrex, "~> 0.17"},
-
-      # Database check
-      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
```

### 2.2 - Remove `phoenix_ecto`

```diff
       {:phoenix_live_view, "~> 1.0"},
-      {:phoenix_ecto, "~> 4.4"},
       {:phoenix_live_reload, "~> 1.4", only: :dev},
```

### 2.3 - Remove `telemetry_ui` (requires Ecto backend)

```diff
-      # Telemetry
-      {:telemetry_ui, "~> 5.0"},
```

### 2.4 - Change `ex_machina` from Ecto mode to plain mode

Keep the dep as-is. The change is in the factory module (Phase 4.6).

### 2.5 - Remove ecto mix aliases

```diff
   defp aliases do
     [
       "assets.deploy": [
         "esbuild default --minify",
         "phx.digest"
-      ],
-      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
-      "ecto.reset": ["ecto.drop", "ecto.setup"],
-      test: ["ecto.create --quiet", "ecto.migrate", "test"]
+      ]
     ]
   end
```

---

## Phase 3: Clean up config files

### 3.1 - `config/config.exs`

Remove Repo config block (lines 12-15):

```diff
 config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

-config :elixir_boilerplate, ElixirBoilerplate.Repo,
-  migration_primary_key: [type: :binary_id, default: {:fragment, "gen_random_uuid()"}],
-  migration_timestamps: [type: :utc_datetime_usec],
-  start_apps_before_migration: [:ssl]
-
 config :elixir_boilerplate, ElixirBoilerplateGraphQL, token_limit: 2000
```

Remove `ecto_repos` from app config (lines 25-27):

```diff
-config :elixir_boilerplate,
-  ecto_repos: [ElixirBoilerplate.Repo],
-  version: version
+config :elixir_boilerplate, version: version
```

### 3.2 - `config/runtime.exs`

Remove Repo config block (lines 7-11):

```diff
 static_uri = get_env("STATIC_URL", :uri)

-config :elixir_boilerplate, ElixirBoilerplate.Repo,
-  url: get_env!("DATABASE_URL"),
-  ssl: get_env("DATABASE_SSL", :boolean),
-  pool_size: get_env!("DATABASE_POOL_SIZE", :integer),
-  socket_options: if(get_env("DATABASE_IPV6", :boolean), do: [:inet6], else: [])
-
 config :elixir_boilerplate,
```

### 3.3 - `config/test.exs`

Remove `TestEnvironment` module and Repo config (lines 3-23):

```diff
 import Config

-defmodule TestEnvironment do
-  @moduledoc false
-  @database_name_suffix "_test"
-
-  def get_database_url do
-    url = System.get_env("DATABASE_URL")
-
-    if is_nil(url) || String.ends_with?(url, @database_name_suffix) do
-      url
-    else
-      raise "Expected database URL to end with '#{@database_name_suffix}', got: #{url}"
-    end
-  end
-end
-
 # This config is to output keys instead of translated message in test
 config :elixir_boilerplate, ElixirBoilerplate.Gettext, priv: "priv/null", interpolation: ElixirBoilerplate.GettextInterpolation

-config :elixir_boilerplate, ElixirBoilerplate.Repo,
-  pool: Ecto.Adapters.SQL.Sandbox,
-  url: TestEnvironment.get_database_url()
-
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint, server: false
```

---

## Phase 4: Remove references in application code

### 4.1 - `lib/elixir_boilerplate/application.ex`

Remove `Repo` from supervision tree and `TelemetryUI` child (depends on Ecto backend):

```diff
   def start(_type, _args) do
     children = [
-      ElixirBoilerplate.Repo,
       {Phoenix.PubSub, [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2]},
-      ElixirBoilerplateWeb.Endpoint,
-      {TelemetryUI, ElixirBoilerplate.TelemetryUI.config()}
+      ElixirBoilerplateWeb.Endpoint
     ]
```

### 4.2 - `lib/elixir_boilerplate_web/endpoint.ex`

Remove `Phoenix.Ecto.CheckRepoStatus` plug (line 37):

```diff
     plug(Phoenix.LiveReloader)
     plug(Phoenix.CodeReloader)
-    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :elixir_boilerplate)
   end
```

### 4.3 - `lib/elixir_boilerplate/telemetry_ui/` - Delete entire directory

Since `telemetry_ui` requires `EctoPostgres` backend, remove it entirely:

```bash
rm -rf lib/elixir_boilerplate/telemetry_ui
```

### 4.4 - `lib/elixir_boilerplate_web/errors/errors.ex`

Remove `Ecto.Changeset` alias and `changeset_to_error_messages/1` function:

```diff
   import Phoenix.Template, only: [embed_templates: 1]

-  alias Ecto.Changeset
-
   embed_templates("templates/*")

-  @doc """
-  Generates a human-readable block containing all errors in a changeset. Errors
-  are then localized using translations in the `ecto` domain.
-
-  For example, you could have an `errors.po` file in the french locale:
-
-  ```
-  msgid ""
-  msgstr ""
-  "Language: fr"
-
-  msgid "can't be blank"
-  msgstr "ne peut être vide"
-  ```
-  """
-  def changeset_to_error_messages(changeset) do
-    changeset
-    |> Changeset.traverse_errors(&translate_error/1)
-    |> convert_errors_to_html(changeset.data.__struct__)
-  end
-
-  defp translate_error({message, options}) do
-    if options[:count] do
-      Gettext.dngettext(ElixirBoilerplate.Gettext, "errors", message, message, options[:count], options)
-    else
-      Gettext.dgettext(ElixirBoilerplate.Gettext, "errors", message, options)
-    end
-  end
-
-  defp convert_errors_to_html(errors, schema) do
-    errors = Enum.reduce(errors, [], &convert_error_field(&1, &2, schema))
-
-    error_messages(%{errors: errors})
-  end
-
-  defp convert_error_field({field, errors}, memo, schema) when is_list(errors) do
-    memo ++ Enum.flat_map(errors, &convert_error_subfield(&1, field, [], schema))
-  end
-
-  defp convert_error_field({field, errors}, memo, schema) when is_map(errors) do
-    memo ++ Enum.flat_map(Map.keys(errors), &convert_error_subfield(&1, field, errors[&1], schema))
-  end
-
-  defp convert_error_subfield(message, field, _, _schema) when is_binary(message) do
-    ["#{field} #{message}"]
-  end
-
-  defp convert_error_subfield(message, field, memo, schema) when is_map(message) do
-    Enum.reduce(message, memo, fn {subfield, errors}, memo ->
-      memo ++ convert_error_field({"#{field}.#{subfield}", errors}, memo, schema)
-    end)
-  end
-
-  defp convert_error_subfield(subfield, field, errors, schema) do
-    field = "#{field}.#{subfield}"
-    convert_error_field({field, errors}, [], schema)
-  end
```

### 4.5 - `lib/elixir_boilerplate.ex`

Update moduledoc to remove database reference:

```diff
-  Contexts are also responsible for managing your data, regardless
-  if it comes from the database, an external API or others.
+  Contexts are also responsible for managing your data, regardless
+  if it comes from an external API or others.
```

---

## Phase 5: Clean up test files

### 5.1 - `test/test_helper.exs`

Remove Sandbox line:

```diff
 {:ok, _} = Application.ensure_all_started(:ex_machina)

 ExUnit.start()
-
-Ecto.Adapters.SQL.Sandbox.mode(ElixirBoilerplate.Repo, :manual)
```

### 5.2 - `test/support/conn_case.ex`

Remove Sandbox aliases and setup:

```diff
   use ExUnit.CaseTemplate

-  alias Ecto.Adapters.SQL.Sandbox
-  alias ElixirBoilerplate.Repo
   alias ElixirBoilerplateWeb.Endpoint
   alias Phoenix.ConnTest
```

```diff
   setup tags do
-    :ok = Sandbox.checkout(Repo)
-
-    if !tags[:async] do
-      Sandbox.mode(Repo, {:shared, self()})
-    end
-
     {:ok, conn: %{ConnTest.build_conn() | host: host()}}
   end
```

Update moduledoc to remove database references (lines 7-13):

```diff
-  to build common datastructures and query the data layer.
-
-  Finally, if the test case interacts with the database,
-  it cannot be async. For this reason, every test runs
-  inside a transaction which is reset at the beginning
-  of the test unless the test case is marked as async.
+  to build common datastructures and query the data layer.
```

### 5.3 - `test/support/channel_case.ex`

Remove Sandbox aliases and setup:

```diff
   use ExUnit.CaseTemplate

-  alias Ecto.Adapters.SQL.Sandbox
-  alias ElixirBoilerplate.Repo
   alias ElixirBoilerplateWeb.Endpoint
```

```diff
   setup tags do
-    :ok = Sandbox.checkout(Repo)
-
-    if !tags[:async] do
-      Sandbox.mode(Repo, {:shared, self()})
-    end
-
     :ok
   end
```

Update moduledoc to remove database references (lines 7-13):

```diff
-  to build common datastructures and query the data layer.
-
-  Finally, if the test case interacts with the database,
-  it cannot be async. For this reason, every test runs
-  inside a transaction which is reset at the beginning
-  of the test unless the test case is marked as async.
+  to build common datastructures and query the data layer.
```

### 5.4 - `test/support/factory.ex`

Switch from `ExMachina.Ecto` to plain `ExMachina`:

```diff
-  use ExMachina.Ecto, repo: ElixirBoilerplate.Repo
+  use ExMachina
```

### 5.5 - `test/elixir_boilerplate/factory_test.exs`

Replace `DataCase` with `ExUnit.Case`:

```diff
-  use ElixirBoilerplate.DataCase, async: true
+  use ExUnit.Case, async: true
```

### 5.6 - `test/elixir_boilerplate_web/errors_test.exs`

Replace entire file. The test depended on `Ecto.Schema`/`Ecto.Changeset` and `changeset_to_error_messages/1` which are removed. Delete the file:

```bash
rm test/elixir_boilerplate_web/errors_test.exs
```

---

## Phase 6: Clean up Docker & CI

### 6.1 - `docker-compose.yml`

Remove postgresql service, volume, DATABASE_URL env, and depends_on:

```diff
 services:
   application:
     image: elixir_boilerplate:0.0.1
     container_name: elixir_boilerplate
     env_file: .env.dev
-    environment:
-      - DATABASE_URL=postgres://postgres:development@postgresql/elixir_boilerplate_dev
     ports:
       - 4000:4000
-    depends_on:
-      - postgresql
-  postgresql:
-    image: postgres:14-bookworm
-    container_name: elixir_boilerplate-postgres
-    environment:
-      - POSTGRES_DB=elixir_boilerplate_dev
-      - POSTGRES_PASSWORD=development
-    ports:
-      - 5432:5432
-    volumes:
-      - elixir_boilerplate_psql:/var/lib/postgresql/data
-volumes:
-  elixir_boilerplate_psql:
```

### 6.2 - `Dockerfile`

Remove migrate from CMD (line 107):

```diff
-CMD ["sh", "-c", "/app/bin/migrate && /app/bin/server"]
+CMD ["/app/bin/server"]
```

### 6.3 - `.github/workflows/ci.yaml`

Remove postgres service block (lines 19-26):

```diff
   ci:
     runs-on: ubuntu-latest

-    services:
-      db:
-        image: postgres:14
-        env:
-          POSTGRES_DB: elixir_boilerplate_test
-          POSTGRES_PASSWORD: development
-        ports: ["5432:5432"]
-        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
-
     env:
```

---

## Phase 7: Clean up environment files

### 7.1 - `.env.dev`

Remove database config block (lines 20-26):

```diff
 SESSION_SIGNING_SALT= # Generate salt with `mix phx.gen.secret`

-# Database configuration
-# - Use `postgres://localhost/elixir_boilerplate_dev` if you have a local PostgreSQL server
-# - Use `postgres://username:password@localhost/elixir_boilerplate_dev` if you have a local PostgreSQL server with credentials
-# - Use `postgres://postgres:development@localhost/elixir_boilerplate_dev` if you're using the PostgreSQL server provided by Docker Compose
-DATABASE_URL=postgres://localhost/elixir_boilerplate_dev
-DATABASE_POOL_SIZE=20
-DATABASE_SSL=false
-
 # URL configuration (used by Phoenix to build URLs from routes)
```

### 7.2 - `.env.test`

Remove database config block (lines 18-23):

```diff
 SESSION_SIGNING_SALT=qh+vmMHsOqcjKF3TSSIsghwt2go48m2+IQ+kMTOB3BrSysSr7D4a21uAtt4yp4wn

-# Database configuration
-# - Use `postgres://localhost/elixir_boilerplate_test` if you have a local PostgreSQL server
-# - Use `postgres://username:password@localhost/elixir_boilerplate_test` if you have a local PostgreSQL server with credentials
-# - Use `postgres://postgres:development@localhost/elixir_boilerplate_test` if you're using the PostgreSQL server provided by Docker Compose
-DATABASE_URL=postgres://postgres:development@localhost/elixir_boilerplate_test
-DATABASE_POOL_SIZE=5
-
 # URL configuration (used by Phoenix to build URLs from routes)
```

### 7.3 - `.env.dev.local`

Remove database lines (lines 8-10):

```diff
 SESSION_SIGNING_SALT=8Dd39JfiSmDUwrpBoiahqYp8oIZ0rb4St7agNsICSXTeL3F92egl/OiuzDc22j7qRKEtusydmh9OtuwhMCIQRQ==

-DATABASE_URL=postgres://postgres:development@localhost:5436/elixir_boilerplate_dev
-DATABASE_POOL_SIZE=20
-DATABASE_SSL=false
-
 CANONICAL_URL=http://localhost:4005
```

### 7.4 - `.env.test.local`

Remove database lines (lines 3-4):

```diff
 MIX_ENV=test
-DATABASE_URL=postgres://postgres:development@localhost:5436/elixir_boilerplate_test
-DATABASE_POOL_SIZE=2
 CANONICAL_URL=http://localhost:4005
```

---

## Phase 8: Clean up ancillary files

### 8.1 - `.credo.exs`

Remove `ExcellentMigrations` check (lines 83-84):

```diff
           {CredoNaming.Check.Consistency.ModuleFilename,
            excluded_paths: ["config", "mix.exs", "priv", "test/support"], acronyms: [{"ElixirBoilerplateGraphQL", "elixir_boilerplate_graphql"}, {"GraphQL", "graphql"}]},
-
-          # Database
-          {ExcellentMigrations.CredoCheck.MigrationsSafety, []}
         ],
```

---

## Phase 9: Finalize

Run `mix deps.get` to update lock file, then `mix compile` to verify everything compiles.

```bash
mix deps.get
mix compile --warnings-as-errors
mix test
mix credo
```
