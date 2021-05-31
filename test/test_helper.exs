# NOTE: When using Elixir 1.12+, we could ditch the next line and use `mix test --warnings-as-errors` instead
Code.put_compiler_option(:warnings_as_errors, true)

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ElixirBoilerplate.Repo, :manual)
