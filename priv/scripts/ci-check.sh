#!/usr/bin/env sh

error_status=0

RED='\033[0;31m'
RED_BOLD='\033[1;31m'
GREEN='\033[0;32m'
GREEN_BOLD='\033[1;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'

header() {
  echo "\n\n${YELLOW}▶ $1${NO_COLOR}"
}

run() {
  eval "${@}"
  last_exit_status=${?}

  if [ ${last_exit_status} -ne 0 ]; then
    echo "\n${RED}${@}${NO_COLOR}"
    echo "${RED}↳ Something went wrong. Program exited with ${last_exit_status} ✘${NO_COLOR}"
    error_status=${last_exit_status}
  else
    echo "\n${GREEN}${@}${NO_COLOR}"
    echo "${GREEN}↳ Passed ✔${NO_COLOR}"
  fi
}

header "Code format and linting…"
run make lint

header "Run tests…"
run make test

header "Code coverage…"
run make test-coverage

header "Dialyzer…"
run make dialyze

header "Run seed data…"
run mix run priv/repo/seeds.exs

header "Run dummy data…"
run mix run priv/repo/dummy.exs

header "Build Docker image running an OTP release…"
run make build

if [ ${error_status} -ne 0 ]; then
  echo "\n\n${YELLOW}▶▶ One of the checks ${RED_BOLD}failed${YELLOW}. Please fix it before committing.${NO_COLOR}"
else
  echo "\n\n${YELLOW}▶▶ All checks ${GREEN_BOLD}passed${YELLOW}!${NO_COLOR}"
fi

exit $error_status
