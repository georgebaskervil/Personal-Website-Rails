# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.6
FROM quay.io/evl.ms/fullstaq-ruby:${RUBY_VERSION}-jemalloc-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_ENV="production"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler


# Throw-away build stages to reduce size of final image
FROM base AS prebuild

# Install packages needed to build gems and node modules
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl libyaml-dev node-gyp pkg-config python-is-python3


FROM prebuild AS node

# Install JavaScript dependencies
ARG NODE_VERSION=20.16.0
ARG YARN_VERSION=1.22.22+sha512.a6b2f7906b721bba3d67d4aff083df04dad64c399707841b7acf00f6b133b7ac24255f2652fa22ae3534329dc6180534e98d17432037ff6fd140556e2bb3137e
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Install node modules
COPY package.json yarn.lock ./
RUN --mount=type=cache,id=bld-yarn-cache,target=/root/.yarn \
    YARN_CACHE_FOLDER=/root/.yarn yarn install --frozen-lockfile


FROM prebuild AS build

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,id=bld-gem-cache,sharing=locked,target=/srv/vendor \
    bundle config set app_config .bundle && \
    bundle config set path /srv/vendor && \
    bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    bundle clean && \
    mkdir -p vendor && \
    bundle config set path vendor && \
    cp -ar /srv/vendor .

# Copy node modules
COPY --from=node /rails/node_modules /rails/node_modules
COPY --from=node /usr/local/node /usr/local/node
ENV PATH=/usr/local/node/bin:$PATH

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
ARG UID=1000 \
    GID=1000
RUN groupadd -f -g $GID rails && \
    useradd -u $UID -g $GID rails --create-home --shell /bin/bash && \
    mkdir /data && \
    chown -R rails:rails db log storage tmp /data
USER rails:rails

# Deployment options
ENV DATABASE_URL="sqlite3:///data/production.sqlite3" \
    RUBY_YJIT_ENABLE="1"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
VOLUME /data
CMD ["./bin/rails", "server"]
