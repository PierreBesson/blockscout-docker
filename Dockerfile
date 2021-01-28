FROM bitwalker/alpine-elixir-phoenix:1.10.3

# Install build dependencies
RUN apk --no-cache --update add alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3

# Install Rust
# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"

EXPOSE 4000

ENV VERSION="v3.4.0-beta" \
    PORT=4000 \
    MIX_ENV="prod" \
    SECRET_KEY_BASE="RMgI4C1HSkxsEjdhtGMfwAHfyT6CKWXOgzCboJflfSm4jeAlic52io05KB6mqzc5"

# Clone repo at specific tag
RUN rm -rf /opt/app
RUN git clone --depth 1 --branch "${VERSION}" https://github.com/poanetwork/blockscout.git /opt/app

WORKDIR /opt/app

ARG COIN
RUN if [ "$COIN" != "" ]; then sed -i s/"POA"/"${COIN}"/g apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; fi

# Run phoenix build
RUN mix local.hex --force
RUN mix do deps.get, local.rebar --force, deps.compile
RUN mix compile

# Install blockscout NPM deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd -
RUN cd apps/explorer/ && \
    npm install && \
    apk update && apk del --force-broken-world alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3

RUN mix phx.digest

CMD  mix do ecto.migrate && mix phx.server