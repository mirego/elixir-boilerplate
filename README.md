<div align="center">
  <img src="https://user-images.githubusercontent.com/11348/52080254-520cb580-2565-11e9-8c21-156cf0b7bcf3.png" width="600" />
  <p><br />This repository is the stable base upon which we build our Elixir projects at Mirego.<br />We want to share it with the world so you can build awesome Elixir applications too.</p>
</div>

## Content

This boilerplate comes with batteries included, you’ll find:

- The battle-tested production-ready web framework [Phoenix](https://phoenixframework.org)
- Popular databases integration with [Ecto](https://hexdocs.pm/ecto/Ecto.html)
- Tests with [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html), with coverage
- Linting with [Credo](http://credo-ci.org)
- Formatting with [mix format](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html)
- A [Distillery](https://hexdocs.pm/distillery/home.html) setup with [Docker](https://www.docker.com) integration
- Translations powered by [Gettext](https://hexdocs.pm/gettext/Gettext.html)
- [Dialyzer](https://hexdocs.pm/dialyxir/readme.html)
- Useful utilities for standard web server: [HTTP Basic Auth](https://github.com/CultivateHQ/basic_auth), [canonical host](https://github.com/remiprev/plug_canonical_host)
- Error reporting with [Sentry](https://hexdocs.pm/sentry/readme.html)

## Usage

1. Clone this project (`git clone https://github.com/mirego/elixir-boilerplate.git`)
2. Delete the internal Git directory (`rm -rf .git`)
3. Run the boilerplate setup script (`./boilerplate-setup.sh YourProjectName`)
4. Create a new Git repository (`git init`)
5. Create the initial Git commit (`git commit -a -m "Initial commit"`)

## License

Elixir Boilerplate is © 2017-2019 [Mirego](https://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause). See the [`LICENSE.md`](https://github.com/mirego/phonix-boilerplate/blob/master/LICENSE.md) file.

The drop logo is based on [this lovely icon by Creative Stall](https://thenounproject.com/term/drop/174999), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We’re a team of [talented people](https://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://www.mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.
