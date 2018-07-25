#!/usr/bin/env bash

if [[ -z "$1" ]] ; then
  echo 'You must specify your project name in CamelCase as first argument.'
  exit 0
fi

# Used as the root module of your app
camelCaseBefore="PhoenixBoilerplate"
camelCaseAfter=${1}

# Used as the name of the OTP app
snakeCaseBefore="phoenix_boilerplate"
snakeCaseAfter=$(elixir -e "IO.puts(Macro.underscore \"$1\")")

# Used in package.json and js files
hyphenCaseBefore="phoenix-boilerplate"
hyphenCaseAfter="${snakeCaseAfter/_/-}"

# Template files
find ./config ./test ./lib ./priv -name "*.eex" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+' 2>&1 >/dev/null
find ./config ./test ./lib ./priv -name "*.eex" -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+' 2>&1 >/dev/null

# Elixir compiled files
find ./config ./test ./lib ./priv -name "*.ex" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+' 2>&1 >/dev/null
find ./config ./test ./lib ./priv -name "*.ex" -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+' 2>&1 >/dev/null

# Elixir script files
find ./config ./test ./lib ./priv mix.exs -name "*.exs" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+' 2>&1 >/dev/null
find ./config ./test ./lib ./priv mix.exs -name "*.exs" -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+' 2>&1 >/dev/null

# Package.json and js files
find ./assets/package.json -exec sed -i '' -e "s/$hyphenCaseBefore/$hyphenCaseAfter/g" '{}' '+' 2>&1 >/dev/null
find ./assets -name '*.js' -exec sed -i '' -e "s/$hyphenCaseBefore/$hyphenCaseAfter/g" '{}' '+' 2>&1 >/dev/null

# Travis configuration file
find ./.travis.yml -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+' 2>&1 >/dev/null

# Rename folder and main app file in lib
mv "./lib/${snakeCaseBefore}" "./lib/${snakeCaseAfter}"
mv "./lib/${snakeCaseBefore}.ex" "./lib/${snakeCaseAfter}.ex"
mv "./lib/${snakeCaseBefore}_web" "./lib/${snakeCaseAfter}_web"
mv "./test/${snakeCaseBefore}_web" "./test/${snakeCaseAfter}_web"
