#
# Step 1 - build the JS/CSS assets
#
FROM node:14.15-alpine3.12 AS js-builder

ENV NODE_ENV=prod

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
FROM hexpm/elixir:1.11.2-erlang-23.1.3-alpine-3.12.1 AS otp-builder

ARG APP_NAME
ARG APP_VERSION

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    MIX_ENV=prod

WORKDIR /build

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache git

# Install Erlang dependencies
RUN mix local.rebar --force && \
    mix local.hex --force

# Install dependencies
COPY mix.* ./
RUN mix deps.get --only prod && \
    mix deps.compile

# Compile codebase
COPY config config
COPY lib lib
COPY priv priv
RUN mix compile

# Copy assets from step 1
COPY --from=js-builder /build/priv/static priv/static
RUN mix phx.digest

# Build OTP release
COPY rel rel
RUN mix release

#
# Step 3 - build a lean runtime container
#
FROM alpine:3.12.1

ARG APP_NAME
ARG APP_VERSION

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION}

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache bash openssl

WORKDIR /opt/elixir_boilerplate

# Copy the OTP binary from the build step
COPY --from=otp-builder /build/_build/prod/${APP_NAME}-${APP_VERSION}.tar.gz .
RUN tar -xvzf ${APP_NAME}-${APP_VERSION}.tar.gz && \
    rm ${APP_NAME}-${APP_VERSION}.tar.gz

# Copy Docker entrypoint
COPY priv/scripts/docker-entrypoint.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Create non-root user
RUN adduser -D elixir_boilerplate && \
    chown -R elixir_boilerplate: /opt/elixir_boilerplate
USER elixir_boilerplate

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
