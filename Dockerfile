ARG NODEJS_VERSION=22-bookworm-slim
ARG ELIXIR_VERSION=1.20.3
ARG OTP_VERSION=27.3.4.16
ARG DEBIAN_VERSION=bookworm-20260803-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# -----------------------------------------------
# Stage: npm dependencies
# -----------------------------------------------
FROM node:${NODEJS_VERSION} AS npm-builder

# Install Debian dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

WORKDIR /app

# Install npm dependencies
COPY assets assets
RUN npm ci --prefix assets

# -----------------------------------------------
# Stage: hex dependencies + OTP release
# -----------------------------------------------
FROM ${BUILDER_IMAGE} AS hex-builder

# install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

ENV MIX_ENV=prod
ENV ERL_FLAGS="+JPperf true"

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# install Esbuild so it is cached
RUN mix esbuild.install --if-missing

COPY lib lib
COPY --from=npm-builder /app/assets assets
COPY priv priv

# Compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# -----------------------------------------------
# Stage: Bundle release in a docker image
# -----------------------------------------------
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
  apt-get install -y curl jq libstdc++6 openssl libncurses5 locales && \
  apt-get clean && \
  rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=hex-builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/elixir_boilerplate ./

USER nobody

CMD ["sh", "-c", "/app/bin/migrate && /app/bin/server"]
