FROM postgres:16

ARG PG_REPACK_VERSION=1.5.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    liblz4-dev \
    libreadline-dev \
    libzstd-dev \
    postgresql-server-dev-16 \
    zlib1g-dev \
  && git clone --depth 1 --branch "ver_${PG_REPACK_VERSION}" https://github.com/reorg/pg_repack.git /tmp/pg_repack \
  && make -C /tmp/pg_repack \
  && make -C /tmp/pg_repack install \
  && rm -rf /tmp/pg_repack \
  && rm -rf /var/lib/apt/lists/*
