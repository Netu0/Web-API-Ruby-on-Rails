# syntax=docker/dockerfile:1

# Define Ruby version via build ARG
ARG RUBY_VERSION=3.4.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# App directory
WORKDIR /rails

# Install base dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libmariadb-dev \
    libmariadb-dev-compat \
    libjemalloc2 \
    libvips \
    nodejs \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment defaults
ARG BUNDLE_WITHOUT="development:test"
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="${BUNDLE_WITHOUT}"

# -------------------------
# BUILD STAGE
# -------------------------
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libyaml-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Gemfile early to use cache
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app code
COPY . .

# Precompile application bootsnap (optional for dev)
RUN bundle exec bootsnap precompile app/ lib/

# Fix line endings and executable bits for bin scripts
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# -------------------------
# FINAL STAGE
# -------------------------
FROM base

# Runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libmariadb3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy from build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Add non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint and server
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
