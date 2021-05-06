<div align="center">
  <img src="https://user-images.githubusercontent.com/11348/52080254-520cb580-2565-11e9-8c21-156cf0b7bcf3.png" width="600" />
  <p><br />This repository is the stable base upon which we build our Elixir projects at Mirego.<br />We want to share it with the world so you can build awesome Elixir applications too.</p>
  <a href="https://github.com/mirego/elixir-boilerplate/actions/workflows/ci.yaml"><img src="https://github.com/mirego/elixir-boilerplate/actions/workflows/ci.yaml/badge.svg" /></a>
</div>

## Introduction

To learn more about _why_ we created and maintain this boilerplate project, read our [blog post](https://shift.mirego.com/en/boilerplate-projects).

## Content

This boilerplate comes with batteries included, you’ll find:

- [Phoenix](https://phoenixframework.org), the battle-tested production-ready web framework
- Database integration using [Ecto](https://hexdocs.pm/ecto)
- GraphQL API setup with [Absinthe](https://hexdocs.pm/absinthe), [Absinthe.Plug](https://hexdocs.pm/absinthe_plug), [Dataloader](https://hexdocs.pm/dataloader) and [AbsintheErrorPayload](https://hexdocs.pm/absinthe_error_payload)
- Translations with [Gettext](https://hexdocs.pm/gettext)
- [ExUnit](https://hexdocs.pm/ex_unit) tests, factories using [ExMachina](https://hexdocs.pm/ex_machina) and code coverage using [ExCoveralls](https://hexdocs.pm/excoveralls)
- CORS management with [Corsica](https://github.com/whatyouhide/corsica)
- Opinionated linting with [Credo](http://credo-ci.org)
- Security scanning with [MixAudit](https://hex.pm/packages/mix_audit) and [Sobelow](https://hexdocs.pm/sobelow)
- Healthcheck setup with [plug_checkup](https://hexdocs.pm/plug_checkup)
- OTP release using [`mix release`](https://hexdocs.pm/mix/Mix.Tasks.Release.html) and [Docker](https://www.docker.com)
- Useful utilities for web features: Basic authentication with [BasicAuth](https://hexdocs.pm/basic_auth), canonical host with [PlugCanonicalHost](https://hexdocs.pm/plug_canonical_host), etc.
- Error reporting with [Sentry](https://hexdocs.pm/sentry)
- A clean and useful `README.md` template (in both [english](./BOILERPLATE_README.md) and [french](./BOILERPLATE_README.fr.md))

## Usage

### With GitHub template

1. Click on the [**Use this template**](https://github.com/mirego/elixir-boilerplate/generate) button to create a new repository
2. Clone your newly created project (`git clone https://github.com/you/repo.git`)
3. Run the boilerplate setup script (`./boilerplate-setup.sh YourProjectName`)
4. Commit the changes (`git commit -a -m "Rename elixir-boilerplate parts"`)

### Without GitHub template

1. Clone this project (`git clone https://github.com/mirego/elixir-boilerplate.git`)
2. Delete the internal Git directory (`rm -rf .git`)
3. Run the boilerplate setup script (`./boilerplate-setup.sh YourProjectName`)
4. Create a new Git repository (`git init`)
5. Create the initial Git commit (`git commit -a -m "Initial commit"`)

## Preferred libraries

Some batteries aren’t included since all projects have their own needs and requirements. Here’s a list of our preferred libraries to help you get started:

| Category                    | Libraries                                                                              |
| --------------------------- | -------------------------------------------------------------------------------------- |
| Authentication              | [`ueberauth`](https://hex.pm/packages/ueberauth), [`pow`](https://hex.pm/packages/pow) |
| Asynchronous job processing | [`oban`](https://hex.pm/packages/oban)                                                 |
| Emails                      | [`bamboo`](https://hex.pm/packages/bamboo), [`swoosh`](https://hex.pm/packages/swoosh) |
| File upload                 | [`waffle`](https://hex.pm/packages/waffle)                                             |
| HTTP client                 | [`tesla`](https://hex.pm/packages/tesla)                                               |
| HTML parsing                | [`floki`](https://hex.pm/packages/floki)                                               |
| Pagination                  | [`scrivener`](https://hex.pm/packages/scrivener)                                       |
| Mocks                       | [`mox`](https://hex.pm/packages/mox), [`mimic`](https://hex.pm/packages/mimic)         |
| Search                      | [`elasticsearch`](https://hex.pm/packages/elasticsearch)                               |

## License

Elixir Boilerplate is © 2017-2020 [Mirego](https://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause). See the [`LICENSE.md`](https://github.com/mirego/elixir-boilerplate/blob/master/LICENSE.md) file.

The drop logo is based on [this lovely icon by Creative Stall](https://thenounproject.com/term/drop/174999), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We’re a team of [talented people](https://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://www.mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.
