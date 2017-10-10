if [[ -z "$1" ]] ; then
  echo 'You must specify your project name in CamelCase as first argument.'
  exit 0
fi

# Used as the root module of your app
camelCaseBefore=PhoenixBoilerplate
camelCaseAfter=$1

# Used as the name of the OTP app
snakeCaseBefore=phoenix_boilerplate
snakeCaseAfter=$(elixir -e "IO.puts(Macro.underscore "$1")")

# Used in package.json and js files
hyphenCaseBefore=phoenix-boilerplate
hyphenCaseAfter=$(echo $snakeCaseAfter | sed -e 's/_/\-/g')

# Template files
find ./config ./test ./lib ./priv mix.exs -name "*.eex" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+'

# Elixir compiled files
find ./config ./test ./lib ./priv mix.exs -name "*.ex" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+'
find ./config ./test ./lib ./priv mix.exs -name "*.ex" -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+'

# Elixir script files
find ./config ./test ./lib ./priv mix.exs -name "*.exs" -exec sed -i '' -e "s/$camelCaseBefore/$camelCaseAfter/g" '{}' '+'
find ./config ./test ./lib ./priv mix.exs -name "*.exs" -exec sed -i '' -e "s/$snakeCaseBefore/$snakeCaseAfter/g" '{}' '+'

# Package.json and js files
find ./assets/package.json -exec sed -i '' -e "s/$hyphenCaseBefore/$hyphenCaseAfter/g" '{}' '+'
find ./assets -name '*.js' -exec sed -i '' -e "s/$hyphenCaseBefore/$hyphenCaseAfter/g" '{}' '+'

# Rename folder and main app file in lib
mv ./lib/$snakeCaseBefore ./lib/$snakeCaseAfter
mv ./lib/$snakeCaseBefore.ex ./lib/$snakeCaseAfter.ex
mv ./lib/${snakeCaseBefore}_web ./lib/${snakeCaseAfter}_web
mv ./test/${snakeCaseBefore}_web ./test/${snakeCaseAfter}_web
