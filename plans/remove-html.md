# Plan: Remove HTML / LiveView / Assets

## Phase 1: Delete HTML directories and files

### 1.1 - Delete the Home HTML/LiveView files (keep `controller.ex`)

```bash
rm lib/elixir_boilerplate_web/home/html.ex
rm lib/elixir_boilerplate_web/home/live.ex
rm -rf lib/elixir_boilerplate_web/home/templates
```

Files removed:

- `home/html.ex` - Phoenix Component module with HEEX templates
- `home/live.ex` - Phoenix LiveView with counter/flash demo
- `home/templates/index.html.heex` - Static home page template
- `home/templates/index_live.html.heex` - LiveView home page template
- `home/templates/header.html.heex` - Header component template
- `home/templates/message.html.heex` - Message component template

Files kept (rewritten in Phase 4.1):

- `home/controller.ex` - Will be rewritten as a JSON controller

### 1.2 - Delete the Layouts module (5 files)

```bash
rm -rf lib/elixir_boilerplate_web/layouts
```

Files removed:

- `layouts/layouts.ex` - Layout component module (uses `Phoenix.LiveView.JS`)
- `layouts/templates/root.html.heex` - Root HTML layout (`<!DOCTYPE html>`)
- `layouts/templates/app.html.heex` - App layout with flash messages
- `layouts/templates/live.html.heex` - LiveView layout with flash messages
- `layouts/templates/flash.html.heex` - Flash message component template

### 1.3 - Delete HTML error templates

```bash
rm -rf lib/elixir_boilerplate_web/errors/templates
```

Files removed:

- `errors/templates/error_messages.html.heex` - Error messages as `<ul><li>` list
- `errors/templates/404.html.heex` - Static HTML 404 error page

### 1.4 - Delete session module

```bash
rm lib/elixir_boilerplate_web/session.ex
```

### 1.5 - Delete socket module

```bash
rm lib/elixir_boilerplate_web/socket.ex
```

### 1.6 - Delete entire assets directory

```bash
rm -rf assets
```

Files removed:

- `assets/js/app.ts` - Imports `phoenix_html`, `phoenix`, `phoenix_live_view`; initializes LiveSocket
- `assets/css/app.css` - Styles for home page, flash messages
- `assets/package.json` - npm deps: `phoenix`, `phoenix_html`, `phoenix_live_view`
- `assets/package-lock.json`
- `assets/eslint.config.js`
- `assets/prettier.config.js`
- `assets/.prettierignore`
- `assets/node_modules/`

### 1.7 - Delete static assets

```bash
rm -rf priv/static
```

### 1.8 - Delete Gettext files

```bash
rm -rf priv/gettext
rm lib/elixir_boilerplate/gettext.ex
```

### 1.9 - Delete TelemetryUI module

```bash
rm -rf lib/elixir_boilerplate/telemetry_ui
```

### 1.10 - Delete HTML-related test files

```bash
rm test/elixir_boilerplate_web/errors_test.exs
rm test/elixir_boilerplate/gettext_interpolation_test.exs
rm test/support/gettext_interpolation.ex
rm test/support/channel_case.ex
```

Test kept (rewritten in Phase 4.2):

- `test/elixir_boilerplate_web/home/controller_test.exs`

---

## Phase 2: Rewrite the errors module for JSON-only

Replace `lib/elixir_boilerplate_web/errors/errors.ex` entirely:

```diff
 defmodule ElixirBoilerplateWeb.Errors do
   @moduledoc false
-  import Phoenix.Template, only: [embed_templates: 1]
-
-  alias Ecto.Changeset
-
-  embed_templates("templates/*")
-
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
-    # NOTE `schema` is available here if we want to use something like
-    # `schema.humanize_field(field)` to be able to display `"Email address is
-    # invalid"` instead of `email is invalid"`.
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
+  def render("404.json", _assigns), do: %{errors: %{detail: "Not Found"}}
+  def render("500.json", _assigns), do: %{errors: %{detail: "Internal Server Error"}}
 end
```

---

## Phase 3: Remove references in endpoint.ex

`lib/elixir_boilerplate_web/endpoint.ex` — 4 removals:

### 3.1 - Remove socket lines (lines 9-10)

```diff
-  socket("/socket", ElixirBoilerplateWeb.Socket)
-  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: {ElixirBoilerplateWeb.Session, :config, []}]])
-
```

### 3.2 - Remove Plug.Static (lines 19-28)

```diff
-  # Serve at "/" the static files from "priv/static" directory.
-  #
-  # You should set gzip to true if you are running phoenix.digest
-  # when deploying your static files in production.
-  plug(Plug.Static,
-    at: "/",
-    from: :elixir_boilerplate,
-    gzip: true,
-    only: ~w(assets fonts images favicon.svg robots.txt)
-  )
-
```

### 3.3 - Remove LiveReloader from code_reloading block (lines 32-38)

From:

```elixir
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)

    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :elixir_boilerplate)
  end
```

To:

```elixir
  if code_reloading? do
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :elixir_boilerplate)
  end
```

### 3.4 - Remove Plug.MethodOverride (line 55)

```diff
-  plug(Plug.MethodOverride)
```

---

## Phase 4: Replace the router with an `:api` pipeline

Replace `lib/elixir_boilerplate_web/router.ex` entirely:

```diff
 defmodule ElixirBoilerplateWeb.Router do
   use Phoenix.Router
 
-  import Phoenix.LiveView.Router
-
-  pipeline :browser do
-    plug(:accepts, ["html", "json"])
-
-    plug(:session)
-    plug(:fetch_session)
-
-    plug(:protect_from_forgery)
-    plug(:put_secure_browser_headers)
-    plug(:fetch_live_flash)
-
-    plug(:put_layout, {ElixirBoilerplateWeb.Layouts, :app})
-    plug(:put_root_layout, {ElixirBoilerplateWeb.Layouts, :root})
-  end
-
-  scope "/" do
-    pipe_through(:browser)
-
-    # To enable metrics dashboard use `telemetry_ui_allowed: true` as assigns value
-    #
-    # Metrics can contains sensitive data you should protect it under authorization
-    # See https://github.com/mirego/telemetry_ui#security
-    get("/metrics", TelemetryUI.Web, [], assigns: %{telemetry_ui_allowed: false})
-  end
-
-  scope "/", ElixirBoilerplateWeb do
-    pipe_through(:browser)
-
-    get("/", Home.Controller, :index, as: :home)
-  end
-
-  scope "/", ElixirBoilerplateWeb do
-    pipe_through(:browser)
-
-    live("/live", Home.Live, :index, as: :live_home)
-  end
-
-  # The session will be stored in the cookie and signed,
-  # this means its contents can be read but not tampered with.
-  # Set :encryption_salt if you would also like to encrypt it.
-  defp session(conn, _opts) do
-    opts = Plug.Session.init(ElixirBoilerplateWeb.Session.config())
-    Plug.Session.call(conn, opts)
-  end
+  pipeline :api do
+    plug(:accepts, ["json"])
+  end
+
+  scope "/", ElixirBoilerplateWeb do
+    pipe_through(:api)
+
+    get("/", Home.Controller, :index)
+  end
 end
```

### 4.1 - Replace home controller with a JSON controller

Replace `lib/elixir_boilerplate_web/home/controller.ex` (instead of deleting the whole `home/` directory in Phase 1, keep only `controller.ex`):

**Update Phase 1.1:** Only delete the HTML-specific files, keep `home/controller.ex`:

```bash
rm lib/elixir_boilerplate_web/home/html.ex
rm lib/elixir_boilerplate_web/home/live.ex
rm -rf lib/elixir_boilerplate_web/home/templates
```

Then replace `lib/elixir_boilerplate_web/home/controller.ex`:

```diff
 defmodule ElixirBoilerplateWeb.Home.Controller do
-  use Phoenix.Controller, namespace: ElixirBoilerplateWeb
+  use Phoenix.Controller
 
-  plug(:put_view, ElixirBoilerplateWeb.Home.HTML)
+  def index(conn, _params) do
+    json(conn, %{status: "ok", message: "Welcome to ElixirBoilerplate API"})
+  end
+end
+```

### 4.2 - Replace home controller test

Replace `test/elixir_boilerplate_web/home/controller_test.exs`:

```diff
-defmodule ElixirBoilerplateWeb.Home.ControllerTest do
-  use ElixirBoilerplateWeb.ConnCase
-
-  test "GET /", %{conn: conn} do
-    conn = get(conn, "/")
-    assert html_response(conn, 200) =~ "Hello, world!"
-  end
-end
+defmodule ElixirBoilerplateWeb.Home.ControllerTest do
+  use ElixirBoilerplateWeb.ConnCase
+
+  test "GET /", %{conn: conn} do
+    conn = get(conn, "/")
+    assert json_response(conn, 200) == %{"status" => "ok", "message" => "Welcome to ElixirBoilerplate API"}
+  end
+end
```

---

## Phase 5: Simplify the security plug

Replace `lib/elixir_boilerplate_web/plugs/security.ex` with an API-oriented version:

```diff
 defmodule ElixirBoilerplateWeb.Plugs.Security do
   @moduledoc false
   @behaviour Plug

-  import Phoenix.Controller, only: [put_secure_browser_headers: 2]
+  import Plug.Conn

-  @doc """
-  This plug adds Phoenix secure HTTP headers including a
-  "Content-Security-Policy" header to responses.You will need to customize each
-  policy directive to fit your application needs.
-  """
-
   def init(opts), do: opts

   def call(conn, _) do
-    directives = [
-      "default-src #{default_src_directive()}",
-      "form-action #{form_action_directive()}",
-      "media-src #{media_src_directive()}",
-      "img-src #{image_src_directive()}",
-      "script-src #{script_src_directive()}",
-      "font-src #{font_src_directive()}",
-      "connect-src #{connect_src_directive()}",
-      "style-src #{style_src_directive()}",
-      "frame-src #{frame_src_directive()}"
-    ]
-
-    put_secure_browser_headers(conn, %{"content-security-policy" => Enum.join(directives, "; ")})
+    conn
+    |> put_resp_header("x-frame-options", "DENY")
+    |> put_resp_header("x-content-type-options", "nosniff")
+    |> put_resp_header("x-xss-protection", "1; mode=block")
+    |> put_resp_header("content-security-policy", "default-src 'none'; frame-ancestors 'none'")
   end
-
-  defp default_src_directive, do: "'none'"
-  defp form_action_directive, do: "'self'"
-  defp media_src_directive, do: "'self'"
-  defp font_src_directive, do: "'self'"
-  defp connect_src_directive, do: "'self'"
-  defp style_src_directive, do: "'self' 'unsafe-inline'"
-  defp frame_src_directive, do: "'self'"
-  defp image_src_directive, do: "'self' data:"
-
-  defp script_src_directive do
-    if Application.get_env(:elixir_boilerplate, __MODULE__)[:allow_unsafe_scripts] do
-      "'self' 'unsafe-eval' 'unsafe-inline'"
-    else
-      "'self' 'unsafe-inline'"
-    end
-  end
 end
```

---

## Phase 6: Remove from application supervision tree

`lib/elixir_boilerplate/application.ex` — remove TelemetryUI child and PubSub (no more consumers):

```diff
   def start(_type, _args) do
     children = [
       ElixirBoilerplate.Repo,
-      {Phoenix.PubSub, [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2]},
-      ElixirBoilerplateWeb.Endpoint,
-      {TelemetryUI, ElixirBoilerplate.TelemetryUI.config()}
+      ElixirBoilerplateWeb.Endpoint
     ]
```

---

## Phase 7: Remove dependencies from `mix.exs`

### 7.1 - Remove 5 dependency lines

```diff
-      # Assets bundling
-      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
-
       # HTTP Client
```

```diff
       {:phoenix, "~> 1.7"},
-      {:phoenix_html, "~> 3.3"},
-      {:phoenix_live_view, "~> 1.0"},
       {:phoenix_ecto, "~> 4.4"},
-      {:phoenix_live_reload, "~> 1.4", only: :dev},
```

```diff
-      # Translations
-      {:gettext, "~> 1.0", override: true},
-
       # Errors
```

```diff
-      # Telemetry
-      {:telemetry_ui, "~> 5.0"},
-
       # Linting
```

### 7.2 - Remove `assets.deploy` alias (lines 36-39)

```diff
   defp aliases do
     [
-      "assets.deploy": [
-        "esbuild default --minify",
-        "phx.digest"
-      ],
       "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
```

---

## Phase 8: Clean up config files

### 8.1 - `config/config.exs`

Remove Gettext config (line 10):

```diff
 config :elixir_boilerplate, Corsica, allow_headers: :all
-config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"
```

Change `render_errors` to JSON-only (line 21):

```diff
-  render_errors: [view: ElixirBoilerplateWeb.Errors, accepts: ~w(html json)]
+  render_errors: [view: ElixirBoilerplateWeb.Errors, accepts: ~w(json)]
```

Remove Security plug config (line 23):

```diff
-config :elixir_boilerplate, ElixirBoilerplateWeb.Plugs.Security, allow_unsafe_scripts: false
-
 config :elixir_boilerplate,
```

Remove PubSub config (line 20):

```diff
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
-  pubsub_server: ElixirBoilerplate.PubSub,
   render_errors: [view: ElixirBoilerplateWeb.Errors, accepts: ~w(json)]
```

Remove entire esbuild config (lines 29-35):

```diff
-config :esbuild,
-  version: "0.16.4",
-  default: [
-    args: ~w(js/app.ts --bundle --target=es2020 --outdir=../priv/static/assets),
-    cd: Path.expand("../assets", __DIR__),
-    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
-  ]
-
 config :logger, backends: [:console, Sentry.LoggerBackend]
```

### 8.2 - `config/dev.exs`

Remove esbuild watcher (lines 7-8):

```diff
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
   code_reloader: true,
   debug_errors: true,
-  check_origin: false,
-  watchers: [
-    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
-  ],
-  live_reload: [
-    patterns: [
-      ~r{priv/gettext/.*$},
-      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
-      ~r{lib/elixir_boilerplate_web/.*(ee?x)$}
-    ]
-  ]
+  check_origin: false
```

Remove Security plug dev config (line 18):

```diff
-config :elixir_boilerplate, ElixirBoilerplateWeb.Plugs.Security, allow_unsafe_scripts: true
-
 config :logger, :console, format: "[$level] $message\n"
```

### 8.3 - `config/prod.exs`

Remove `cache_static_manifest` (line 4):

```diff
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
-  cache_static_manifest: "priv/static/cache_manifest.json",
   debug_errors: false
```

### 8.4 - `config/test.exs`

Remove Gettext test config (line 19):

```diff
-# This config is to output keys instead of translated message in test
-config :elixir_boilerplate, ElixirBoilerplate.Gettext, priv: "priv/null", interpolation: ElixirBoilerplate.GettextInterpolation
-
 config :elixir_boilerplate, ElixirBoilerplate.Repo,
```

### 8.5 - `config/runtime.exs`

Remove `static_uri` (line 5):

```diff
 canonical_uri = get_env("CANONICAL_URL", :uri)
-static_uri = get_env("STATIC_URL", :uri)
```

Remove TelemetryUI share_key config (line 27):

```diff
 config :elixir_boilerplate, Corsica, origins: get_env("CORS_ALLOWED_ORIGINS", :cors)
-config :elixir_boilerplate, ElixirBoilerplate.TelemetryUI, share_key: get_env("TELEMETRY_UI_SHARE_KEY")
```

Remove session/live_view/static_url from endpoint config (lines 32-34, 36):

```diff
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
   http: [port: get_env!("PORT", :integer)],
   secret_key_base: get_env!("SECRET_KEY_BASE"),
-  session_key: get_env!("SESSION_KEY"),
-  session_signing_salt: get_env!("SESSION_SIGNING_SALT"),
-  live_view: [signing_salt: get_env!("SESSION_SIGNING_SALT")],
-  url: get_endpoint_url_config(canonical_uri),
-  static_url: get_endpoint_url_config(static_uri)
+  url: get_endpoint_url_config(canonical_uri)
```

---

## Phase 9: Clean up `.env.dev`

Remove session keys (lines 17-18):

```diff
 SECRET_KEY_BASE= # Generate secret with `mix phx.gen.secret`
-SESSION_KEY=elixir_boilerplate
-SESSION_SIGNING_SALT= # Generate salt with `mix phx.gen.secret`
```

Remove TelemetryUI share key (lines 34-35):

```diff
-# Telemtry UI configuration
-TELEMETRY_UI_SHARE_KEY= # Generate 15 random characters with `mix phx.gen.secret | cut -c 1-15`
```

Remove static URL block (lines 37-41):

```diff
-# Static URL configuration (used by Phoenix to generate static file URLs, eg.
-# CSS and JavaScript). We often use these variables to configure a CDN that
-# will cache static files once they have been served by the Phoenix
-# application.
-# STATIC_URL=
```

---

## Phase 10: Clean up Makefile

Remove `PRETTIER_FILES_PATTERN` and `STYLES_PATTERN` variables (lines 15-16):

```diff
-PRETTIER_FILES_PATTERN = '*.config.js' '{js,css,scripts}/**/*.{js,graphql,scss,css}' '../*.md' '../*/*.md'
-STYLES_PATTERN = 'css'
```

Remove `npm ci` from `prepare` target (line 62):

```diff
 prepare:
 	mix deps.get
-	npm ci --prefix assets
```

Remove `npm install` from `dependencies` target (line 83):

```diff
 dependencies: ## Install hex and npm dependencies
 	mix deps.get
-	npm install --prefix assets
```

Remove `cd assets && npx prettier` from `check-format` (line 114):

```diff
 check-format:
 	mix format --check-formatted
-	cd assets && npx prettier --check $(PRETTIER_FILES_PATTERN)
```

Remove `cd assets && npx prettier` from `format` (line 127):

```diff
 format: ## Format source files
 	mix format
-	cd assets && npx prettier --write $(PRETTIER_FILES_PATTERN)
```

Change `lint` to remove `lint-scripts` (line 130):

```diff
-lint: lint-elixir lint-scripts ## Lint source files
+lint: lint-elixir ## Lint source files
```

Remove entire `lint-scripts` target (lines 137-139):

```diff
-.PHONY: lint-scripts
-lint-scripts:
-	cd assets && npx eslint .
```

---

## Phase 11: Clean up Dockerfile

Remove entire `npm-builder` stage (lines 9-24):

```diff
-# -----------------------------------------------
-# Stage: npm dependencies
-# -----------------------------------------------
-FROM node:${NODEJS_VERSION} AS npm-builder
-
-# Install Debian dependencies
-RUN apt-get update -y && \
-    apt-get install -y build-essential git && \
-    apt-get clean && \
-    rm -f /var/lib/apt/lists/*_*
-
-WORKDIR /app
-
-# Install npm dependencies
-COPY assets assets
-RUN npm ci --prefix assets
```

Remove `NODEJS_VERSION` ARG (line 1):

```diff
-ARG NODEJS_VERSION=22-bookworm-slim
 ARG ELIXIR_VERSION=1.18.1
```

Remove esbuild install, asset copy, and asset compilation (lines 62, 65, 68-69):

```diff
-# install Esbuild so it is cached
-RUN mix esbuild.install --if-missing
-
 COPY lib lib
-COPY --from=npm-builder /app/assets assets
 COPY priv priv
-
-# Compile assets
-RUN mix assets.deploy
```

---

## Phase 12: Clean up ancillary files

### 12.1 - `.gitignore`

Remove asset-related lines (lines 15-20):

```diff
-# Static artifacts
-/assets/node_modules
-
-# Ignore assets that are produced by build tools
-/priv/static/*
-!/priv/static/favicon.svg
```

### 12.2 - `.credo.exs`

No changes needed for HTML removal specifically (GraphQL acronyms are handled by the remove-graphql plan).

### 12.3 - `test/support/conn_case.ex`

Remove route helpers import (line 26):

```diff
     quote do
-      # Import conveniences for testing with connections
-      import ElixirBoilerplateWeb.Router.Helpers
       import Phoenix.ConnTest
```
