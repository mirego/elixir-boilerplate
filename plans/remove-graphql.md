# Plan: Remove GraphQL / Absinthe

## Phase 1: Delete GraphQL directory

Delete the entire `lib/elixir_boilerplate_graphql/` directory (7 files):

```bash
rm -rf lib/elixir_boilerplate_graphql
```

Files removed:

- `elixir_boilerplate_graphql.ex` - Main module, Absinthe pipeline config
- `schema.ex` - Root Absinthe schema, Dataloader, NewRelic middleware
- `router.ex` - Plug.Router forwarding `/graphql` to Absinthe.Plug
- `application/types.ex` - GraphQL object/query type definitions
- `plugs/context.ex` - Sets `:absinthe` private on conn
- `middleware/operation_name_logger.ex` - Logs GraphQL operation name
- `middleware/error_reporting.ex` - Reports GraphQL errors to Sentry

---

## Phase 2: Remove references to deleted modules

### 2.1 - `lib/elixir_boilerplate_web/endpoint.ex`

Remove line 59:

```diff
  plug(ElixirBoilerplateHealth.Router)
- plug(ElixirBoilerplateGraphQL.Router)
  plug(:halt_if_sent)
```

### 2.2 - `lib/elixir_boilerplate/telemetry_ui/telemetry_ui.ex`

4 removals (work bottom-up to avoid line shift issues):

1. Delete the entire `graphql_metrics/0` private function (lines 144-229)
2. Delete the entire `absinthe_metrics/0` private function (lines 107-141)
3. Remove "GraphQL" and "Absinthe" entries from the metrics pages list

The metrics list goes from:

```elixir
metrics: [
  {"HTTP", http_metrics(), ui_options: ui_options},
  {"GraphQL", graphql_metrics(), ui_options: [metrics_class: "grid-cols-8 gap-4"]},
  {"Absinthe", absinthe_metrics(), ui_options: [metrics_class: "grid-cols-8 gap-4"]},
  {"Ecto", ecto_metrics(), ui_options: ui_options},
  {"System", system_metrics()}
],
```

To:

```elixir
metrics: [
  {"HTTP", http_metrics(), ui_options: ui_options},
  {"Ecto", ecto_metrics(), ui_options: ui_options},
  {"System", system_metrics()}
],
```

---

## Phase 3: Remove dependencies from `mix.exs`

Remove 6 dependency lines + the `# GraphQL` comment:

```diff
-      # GraphQL
-      {:absinthe, "~> 1.7"},
-      {:absinthe_security, "~> 0.1"},
-      {:absinthe_plug, "~> 1.5"},
-      {:dataloader, "~> 2.0"},
-      {:absinthe_error_payload, "~> 1.1"},
```

And under `# Monitoring`:

```diff
       {:new_relic_agent, "~> 1.27"},
-      {:new_relic_absinthe, "~> 0.0"},
```

---

## Phase 4: Clean up config files

### 4.1 - `config/config.exs`

Remove absinthe_security block (lines 5-7) and blank line after:

```diff
 version = Mix.Project.config()[:version]

-config :absinthe_security, AbsintheSecurity.Phase.MaxAliasesCheck, max_alias_count: 100
-config :absinthe_security, AbsintheSecurity.Phase.MaxDepthCheck, max_depth_count: 100
-config :absinthe_security, AbsintheSecurity.Phase.MaxDirectivesCheck, max_directive_count: 100
-
 config :elixir_boilerplate, Corsica, allow_headers: :all
```

Remove token_limit config (line 17) and blank line after:

```diff
-config :elixir_boilerplate, ElixirBoilerplateGraphQL, token_limit: 2000
-
 config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
```

### 4.2 - `config/runtime.exs`

Remove lines 23-24 and blank line after:

```diff
 end

-config :absinthe_security, AbsintheSecurity.Phase.FieldSuggestionsCheck, enable_field_suggestions: get_env("GRAPHQL_ENABLE_FIELD_SUGGESTIONS", :boolean)
-config :absinthe_security, AbsintheSecurity.Phase.IntrospectionCheck, enable_introspection: get_env("GRAPHQL_ENABLE_INTROSPECTION", :boolean)
-
 config :elixir_boilerplate, Corsica, origins: get_env("CORS_ALLOWED_ORIGINS", :cors)
```

### 4.3 - `config/prod.exs`

Change logger metadata on line 22:

```diff
-  metadata: ~w(request_id graphql_operation_name)a
+  metadata: ~w(request_id)a
```

---

## Phase 5: Clean up ancillary files

### 5.1 - `.env.dev`

Remove last 3 lines (56-58) and the trailing blank line before them:

```diff
 SENTRY_ENVIRONMENT_NAME=local
-
-# Absinthe configuration
-GRAPHQL_ENABLE_INTROSPECTION=true
-GRAPHQL_ENABLE_FIELD_INSPECTION=true
```

### 5.2 - `.credo.exs`

In `CredoNaming.Check.Consistency.ModuleFilename` config (line 80-81), remove the `acronyms` key entirely (it only contains GraphQL entries):

```diff
-          {CredoNaming.Check.Consistency.ModuleFilename,
-           excluded_paths: ["config", "mix.exs", "priv", "test/support"], acronyms: [{"ElixirBoilerplateGraphQL", "elixir_boilerplate_graphql"}, {"GraphQL", "graphql"}]},
+          {CredoNaming.Check.Consistency.ModuleFilename,
+           excluded_paths: ["config", "mix.exs", "priv", "test/support"]},
```

### 5.3 - `Makefile`

On line 15, remove `,graphql` from prettier pattern:

```diff
-PRETTIER_FILES_PATTERN = '*.config.js' '{js,css,scripts}/**/*.{js,graphql,scss,css}' '../*.md' '../*/*.md'
+PRETTIER_FILES_PATTERN = '*.config.js' '{js,css,scripts}/**/*.{js,scss,css}' '../*.md' '../*/*.md'
```
