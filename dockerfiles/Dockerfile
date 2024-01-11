FROM ubuntu:22.04

ARG TARANTOOL_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
    && useradd --user-group --create-home --no-log-init --shell /bin/bash tarantool \
    && apt update && apt -y --no-install-recommends --no-install-suggests install \
    gcc \
    git \
    gosu \
    curl \
    wget \
    unzip \
    gnupg2 \
    lsb-release \
    liblua5.1-dev \
    ca-certificates \
    && curl -L https://download.tarantool.org/tarantool/release/series-3/gpgkey | apt-key add - \
    && curl -L https://download.tarantool.org/tarantool/modules/gpgkey | apt-key add - \
    && echo "deb https://download.tarantool.org/tarantool/release/series-3/linux-deb/ static main" >> /etc/apt/sources.list.d/tarantool.list \
    && echo "deb-src https://download.tarantool.org/tarantool/release/series-3/linux-deb/ static main" >> /etc/apt/sources.list.d/tarantool.list \
    && echo "deb https://download.tarantool.org/tarantool/modules/ubuntu/ $(lsb_release -s -c) main" >> /etc/apt/sources.list.d/tarantool.list \
    && echo "deb-src https://download.tarantool.org/tarantool/modules/ubuntu/ $(lsb_release -s -c) main" >> /etc/apt/sources.list.d/tarantool.list

RUN apt update \
    && apt show -a tarantool \
    && apt -y --no-install-recommends --no-install-suggests install \
    tarantool=${TARANTOOL_VERSION} \
    tarantool-dev=${TARANTOOL_VERSION} \
    tt \
    && tt rocks install lua-term \
    && apt clean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/ \
    && mkdir -p /etc/tarantool \
    && mkdir -p /var/lib/tarantool \
    && mkdir -p /var/run/tarantool \
    && chown -R tarantool:tarantool /etc/tarantool \
    && chown -R tarantool:tarantool /var/lib/tarantool \
    && chown -R tarantool:tarantool /var/run/tarantool

COPY files/tarantool-entrypoint.lua /usr/local/bin/
COPY files/tarantool_set_config.lua /usr/local/bin/
COPY files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY files/console /usr/local/bin/
COPY files/tarantool_is_up /usr/local/bin/

RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

HEALTHCHECK CMD tarantool_is_up

EXPOSE 3301
CMD [ "tarantool" ]
