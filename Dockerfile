ARG ELIXIR_VERSION=1.15.4
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20230612-slim

ARG IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${IMAGE}

WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY lib lib

RUN mix compile

CMD ["mix", "run", "--no-halt"]
