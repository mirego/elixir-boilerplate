#
# Step 1 - build the JS/CSS assets
#
FROM node:10.16-alpine AS js-builder

ARG NODE_ENV=prod

ENV NODE_ENV=${NODE_ENV}

WORKDIR /build

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache git

# Install JS dependencies
COPY assets assets
RUN npm ci --prefix assets --no-audit --no-color --unsafe-perm

# Build JS/CSS assets 
RUN npm run --prefix assets deploy

#
# Step 2 - build the OTP binary
#
FROM elixir:1.9-alpine AS builder

ARG APP_NAME
ARG APP_VERSION
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    MIX_ENV=${MIX_ENV}

WORKDIR /build

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache git

# Install Erlang dependencies
RUN mix local.rebar --force && \
    mix local.hex --force

# Install Hex dependencies
COPY mix.* ./
RUN mix deps.get --only ${MIX_ENV} && \
    mix deps.compile

# Compile codebase
COPY config config
COPY lib lib
COPY priv priv
COPY rel rel
RUN mix compile

# Copy assets from step 1
COPY --from=js-builder /build/priv/static priv/static
RUN mix phx.digest

# Build OTP release
RUN mkdir -p /opt/build && \
    mix release && \
    cp -R _build/${MIX_ENV}/rel/${APP_NAME}/* /opt/build

#
# Step 3 - build a lean runtime container
#
FROM alpine:3.10

ARG APP_NAME
ENV APP_NAME=${APP_NAME}

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache bash openssl-dev erlang-crypto

WORKDIR /opt/elixir_boilerplate

# Copy OTP release from step 2
COPY --from=builder /opt/build .

# Copy Docker entrypoint
COPY priv/scripts/docker-entrypoint.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Create non-root user
RUN adduser -D elixir_boilerplate && \ 
    chown -R elixir_boilerplate: /opt/elixir_boilerplate
USER elixir_boilerplate

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
