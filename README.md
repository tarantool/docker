# Tarantool Docker images

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [What is Tarantool](#what-is-tarantool)
- [Quick start](#quickstart)
- [What's on board](#whats-on-board)
  - [Included modules](#included-modules)
  - [Data directories](#data-directories)
  - [Convenience tools](#convenience-tools)
- [Versions, tags, and release policy](#versions-tags-and-release-policy)
- [How to use these images](#how-to-use-these-images)
  - [Start a Tarantool instance](#start-a-tarantool-instance)
  - [Start a secure Tarantool instance](#start-a-secure-tarantool-instance)
  - [Connect to a running Tarantool instance](#connect-to-a-running-tarantool-instance)
  - [Start a master-master replica set](#start-a-master-master-replica-set)
  - [Add application code with a volume mount](#add-application-code-with-a-volume-mount)
  - [Build your own images](#build-your-own-images)
- [Environment variables](#environment-variables)
  - [`TARANTOOL_USER_NAME`](#tarantool_user_name)
  - [`TARANTOOL_USER_PASSWORD`](#tarantool_user_password)
  - [`TARANTOOL_PORT`](#tarantool_port)
  - [`TARANTOOL_PROMETHEUS_DEFAULT_METRICS_PORT`](#tarantool_prometheus_default_metrics_port)
  - [`TARANTOOL_REPLICATION`](#tarantool_replication)
  - [`TARANTOOL_MEMTX_MEMORY`](#tarantool_memtx_memory)
  - [`TARANTOOL_SLAB_ALLOC_FACTOR`](#tarantool_slab_alloc_factor)
  - [`TARANTOOL_MEMTX_MAX_TUPLE_SIZE`](#tarantool_memtx_max_tuple_size)
  - [`TARANTOOL_MEMTX_MIN_TUPLE_SIZE`](#tarantool_memtx_min_tuple_size)
  - [`TARANTOOL_CHECKPOINT_INTERVAL`](#tarantool_checkpoint_interval)
  - [`TARANTOOL_FORCE_RECOVERY`](#tarantool_force_recovery)
  - [`TARANTOOL_LOG_FORMAT`](#tarantool_log_format)
  - [`TARANTOOL_LOG_LEVEL`](#tarantool_log_level)
- [Reporting problems and getting help](#reporting-problems-and-getting-help)
- [Contributing](#contributing)
  - [How to contribute](#how-to-contribute)
  - [How to check](#how-to-check)
  - [Build pipelines](#build-pipelines)
  - [Release policy](#release-policy)
  - [Exceptional cases](#exceptional-cases)
  - [How to build and push an image](#how-to-build-and-push-an-image)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## What is Tarantool

Tarantool is an in-memory computing platform that combines
a Lua application server and a database management system.
Read more about Tarantool at [tarantool.io](https://www.tarantool.io/en/developers/).

## Quick start

To try out Tarantool, run this command:

```console
$ docker run --rm -t -i tarantool/tarantool
```

It will create a one-off Tarantool instance and open an interactive
console.
From there, you can either type `tutorial()` in the console or follow the
[documentation](https://www.tarantool.io/en/doc/latest/getting_started/getting_started_db/#using-a-docker-image).

## What's on board

The `tarantool/tarantool` images contain the Tarantool executable
and a combination of [Lua modules](#included-modules) and utilities often used in production.
Designed as a building block for modern services, these modules and utilities are based on a few
design choices that set them apart from the systemd-controlled Tarantool.
We check all these extensions for compatibility with the Tarantool version included in the image.

The Docker images come in three flavors, based on three different images: `alpine:3.15`, `centos:7`
and `ubuntu:20.04`. Check them out:

```console
$ docker run --rm -t -i tarantool/tarantool:2.10.0
$ docker run --rm -t -i tarantool/tarantool:2.10.0-centos7
$ docker run --rm -t -i tarantool/tarantool:2.10.0-ubuntu
```

The entrypoint script in each of these images uses
[environment variables](#environment-variables)
to set various configuration options,
such as replication sources, memory limits, and so on.
If specified, the environment variables override the settings provided in your code.
This way, you can set options using `docker compose` or
other orchestration and deployment tools.

There are also a few [convenience tools](#convenience-tools) that make use of the fact that there
is only one Tarantool instance running in the container.

### Included modules

The following Lua modules are included in the build:

- [avro-schema](https://github.com/tarantool/avro-schema): Apache Avro scheme for your data.
- [connpool](https://github.com/tarantool/connpool): Keep a pool of connections to other Tarantool instances.
- [curl](https://github.com/tarantool/curl): HTTP client based on libcurl.
- [expirationd](https://github.com/tarantool/expirationd): Automatically delete tuples based on expiration time.
- [gis](https://github.com/tarantool/gis): Store and query geospatial data.
- [gperftools](https://github.com/tarantool/gperftools): Collect a CPU profile to find bottlenecks in your code.
- [http](https://github.com/tarantool/http): Embedded HTTP server with Flask-style routing support.
- [memcached](https://github.com/tarantool/memcached): Access Tarantool as if it was a memcached instance.
- [metrics](https://github.com/tarantool/metrics): Metric collection library for Tarantool.
- [mqtt](https://github.com/tarantool/mqtt): Client for MQTT message brokers.
- [mysql](https://github.com/tarantool/mysql): Query MySQL right from Tarantool.
- [pg](https://github.com/tarantool/pg): Query PostgreSQL right from Tarantool.
- [prometheus](https://github.com/tarantool/prometheus): Instrument code and export metrics to Prometheus monitoring.
- [queue](https://github.com/tarantool/queue): Priority queues with TTL and confirmations.
- [vshard](https://github.com/tarantool/vshard): Automatically distribute data across multiple instances.


If the module you need is not listed here, there is a good chance we can add it.
Open an issue [on our GitHub](https://github.com/tarantool/docker).

### Data directories

Mount these directories as volumes:

- `/var/lib/tarantool` contains operational data
  (snapshots, xlogs and vinyl runs).

- `/opt/tarantool` is the directory for Lua application code.

### Convenience tools

- `console`: Execute without arguments to open an administrative
  console to a running Tarantool instance.

- `tarantool_is_up`: Returns `0` if Tarantool has been initialized and
  is operating normally.

- `tarantool_set_config.lua`: Allows you to dynamically change certain
  settings without the need to recreate containers.

## Versions, tags, and release policy

The images are built and published on Docker Hub
for each Tarantool release as well as for some beta
and release candidate versions.

There are three variants built from different base images:

* Alpine 3.15, the "default" build with tags having no mention of base image, like `latest`, `1`, `2`, `1.10`,`1.10.z`, `2.y`, `2.y.z` and others.
* CentOS 7 with tags like `1-centos7`, `2-centos7`, and so on.
* Ubuntu 20.04 with tags like `1-ubuntu22.04`, `2-ubuntu22.04`, and so on.

## How to use these images

### Start a Tarantool instance

```console
$ docker run \
  --name mytarantool \
  -p 3301:3301 -d \
  tarantool/tarantool
```

This will start an instance of Tarantool and expose it on
port 3301. Note that by default there is no password protection,
so don't expose this instance to the outside world.

In this case, as there is no Lua code provided, the entrypoint
script initializes the database using a reasonable set of defaults. Some of them
can be tweaked with environment variables (see below).

### Start a secure Tarantool instance

```console
$ docker run \
  --name mytarantool \
  -p 3301:3301 \
  -e TARANTOOL_USER_NAME=myusername \
  -e TARANTOOL_USER_PASSWORD=mysecretpassword -d \
  tarantool/tarantool
```

This starts an instance of Tarantool, disables guest login, and
creates a user named `myusername` with admin privileges and the password
`mysecretpassword`.

As in the previous example, the database is initialized automatically.

### Connect to a running Tarantool instance

```console
$ docker exec -t -i mytarantool console
```

This will open an interactive admin console on the running instance
named `mytarantool`. You can safely detach from it anytime, the server
will continue running.

This `console` doesn't require authentication, because it uses a local
Unix socket in the container to connect to Tarantool. However, it requires
you to have direct access to the container.

If you need to access a remote console via TCP/IP, use the `tarantoolctl` utility
as explained [here](https://www.tarantool.io/en/doc/latest/reference/tarantoolctl/).

### Start a master-master replica set

You can start a replica set with Docker alone, but it's more
convenient to use [docker-compose](https://docs.docker.com/compose/).
Here's a simplified `docker-compose.yml` for starting a master-master
replica set:

``` yaml
version: '2'

services:
  tarantool1:
    image: tarantool/tarantool:latest
    environment:
      TARANTOOL_REPLICATION: "tarantool1,tarantool2"
    networks:
      - mynet
    ports:
      - "3301:3301"

  tarantool2:
    image: tarantool/tarantool:latest
    environment:
      TARANTOOL_REPLICATION: "tarantool1,tarantool2"
    networks:
      - mynet
    ports:
      - "3302:3301"

networks:
  mynet:
    driver: bridge
```

Start it like this:

``` console
$ docker compose up
```

### Add application code with a volume mount

The simplest way to provide application code is to mount your code
directory to `/opt/tarantool`:

```console
$ docker run \
  --name mytarantool \
  -p 3301:3301 -d \
  -v /path/to/my/app:/opt/tarantool \
  tarantool/tarantool \
  tarantool /opt/tarantool/app.lua
```

Here, `/path/to/my/app` is the host directory containing Lua code
and `app.lua` is the entry point of your application.
Note that for your code to run, you must execute the main script explicitly,
which is done in the last line.

### Build your own images

To pack and distribute an image with your code,
create your own `Dockerfile`:

```dockerfile
FROM tarantool/tarantool:2.10.0
COPY app.lua /opt/tarantool
CMD ["tarantool", "/opt/tarantool/app.lua"]
```

Then build it with:

```console
$ docker build -t company/appname:tag .
```

Please pay attention to the format of `CMD`. Unless it is specified in
square brackets, the `wrapper` entrypoint that our Docker image
provides will not be called. In this case, you will not be able to configure
your instance using environment variables.

We recommend building from an image with a precise tag,
that is, `2.10.0` or `2.10.0-centos7`, not
`2.10` or `latest`.
This way you will have more control over the updates of
Tarantool and other dependencies of your application.

## Environment variables

When you run this image, you can adjust some of Tarantool settings.
Most of them either control memory/disk limits or specify external
connectivity parameters.

If you need to fine-tune specific settings not described here, you can
always inherit this container and call `box.cfg{}` yourself.
See the
[documentation on `box.cfg`](https://www.tarantool.io/en/doc/latest/reference/configuration/#box-cfg-params) for
details.

### `TARANTOOL_USER_NAME`

Setting this variable allows you to pick the name of the user that is
utilized for remote connections. By default, it is `guest`. Please
note that since the `guest` user in Tarantool can't have a password, it is
highly recommended that you change it.

### `TARANTOOL_USER_PASSWORD`

For security reasons, it is recommended that you never leave this
variable unset. This environment variable sets the user's password for
Tarantool. In the above example, it is set to `mysecretpassword`.

### `TARANTOOL_PORT`

Optional. Specifying this variable will tell Tarantool to listen for
incoming connections on a specific port. Default is `3301`.

### `TARANTOOL_PROMETHEUS_DEFAULT_METRICS_PORT`

Optional. If specified, Tarantool will start an HTTP server on the provided port
and expose the Prometheus `metrics` endpoint with common metrics
(fibers, memory, network, replication, etc.).

### `TARANTOOL_REPLICATION`

Optional. Comma-separated list of URIs to treat as replication
sources. Upon start, Tarantool will attempt to connect to
those instances, fetch the data snapshot, and start replicating
transaction logs. In other words, it will become a slave. For a
multi-master configuration, other participating instances of
Tarantool should be started with the same `TARANTOOL_REPLICATION`.
(NB: Applicable only to versions later than 1.7.)

Example:

`user1:pass@host1:3301,user2:pass@host2:3301`

### `TARANTOOL_MEMTX_MEMORY`

Optional. Specifies how much memory Tarantool allocates to
actually store tuples, in bytes. When the limit is reached, `INSERT`
or `UPDATE` requests begin failing. Default is `268435456` (256
megabytes).

### `TARANTOOL_SLAB_ALLOC_FACTOR`

Optional. Used as the multiplier for computing the sizes of memory
chunks that tuples are stored in. A lower value may result in less
wasted memory, depending on the total amount of memory available
and the distribution of item sizes. Default is `1.05`.

### `TARANTOOL_MEMTX_MAX_TUPLE_SIZE`

Optional. Size of the largest allocation unit in bytes. It can be
increased if it is necessary to store large tuples. Default is
`1048576`.

### `TARANTOOL_MEMTX_MIN_TUPLE_SIZE`

Optional. Size of the smallest allocation unit, in bytes. It can be
decreased if most of the tuples are very small. Default is `16`.

### `TARANTOOL_CHECKPOINT_INTERVAL`

Optional. Specifies how often snapshots are made, in seconds.
Default is `3600` (every 1 hour).

### `TARANTOOL_FORCE_RECOVERY`

Optional. When set to `true`, Tarantool tries to continue if there is an error while
reading a snapshot file or a write-ahead log file.
Skips invalid records, reads as much data as possible,
print a warning in console and start the database.

### `TARANTOOL_LOG_FORMAT`

Optional. There are two possible log formats:

* 'plain' — the default one.
* 'json' — with more details and with JSON labels.

More details can be found in the
[log module reference](https://www.tarantool.io/en/doc/latest/reference/configuration/#confval-log_format).

### `TARANTOOL_LOG_LEVEL`

Optional. Default value is 5 (that means INFO).
More details can be found in
[log level configuration](https://www.tarantool.io/en/doc/latest/reference/configuration/#cfg-logging-log-level).

## Contributing

### Reporting problems and getting help

You can report problems and request
features [on our GitHub](https://github.com/tarantool/docker).

Alternatively, you may get help on our [Telegram channel](https://t.me/tarantool).

### How to contribute

Open a pull request to the `master` branch.
A maintainer is responsible for merging the PR.

### How to check

Say, we have updated 'dockerfiles/alpine_3.9' and want to check it:

```sh
$ TAG=2 OS=alpine DIST=3.9 VER=2.x PORT=5200 make -f .gitlab.mk build
$ docker run -it tarantool/tarantool:2
...perform a test...
```

### Build pipelines

Fixed release versions:

| Docker tag         | FROM         | Dockerfile              |
|--------------------|--------------|-------------------------|
| 2.10.0             | alpine:3.15  | dockerfile/alpine_3.15  |
| 2.10.0-centos7     | centos:7     | dockerfile/centos_7     |
| 2.10.0-ubuntu20.04 | ubuntu:20.04 | dockerfile/ubuntu_20.04 |
| 2.10.0-rc1         | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.10.0-beta2       | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.10.0-beta1       | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.8.0  .. 2.8.4    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.7.0  .. 2.7.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.6.0  .. 2.6.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.5.0  .. 2.5.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.4.0  .. 2.4.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.3.1  .. 2.3.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.3.0              | alpine:3.5   | dockerfile/alpine_3.5   |
| 2.2.2  .. 2.2.3    | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.2.0  .. 2.2.1    | alpine:3.5   | dockerfile/alpine_3.5   |
| 2.1.3              | alpine:3.9   | dockerfile/alpine_3.9   |
| 2.1.0  .. 2.1.2    | alpine:3.9   | dockerfile/alpine_3.5   |
| 1.10.13            | alpine:3.9   | dockerfile/alpine_3.9   |
| 1.10.4 .. 1.10.12  | alpine:3.9   | dockerfile/alpine_3.9   |
| 1.10.0 .. 1.10.3   | alpine:3.5   | dockerfile/alpine_3.5   |

Rolling versions:

| Docker tag | Dockerfile             |
|-----------|------------------------|
| 2, latest | dockerfile/alpine_3.15 |
| 2-centos7 | dockerfile/centos_7    |
| 1         | dockerfile/alpine_3.15 |
| 1         | dockerfile/alpine_3.15 |
| 2.1 .. 2.8 | dockerfile/alpine_3.9  |
| 2.1 .. 2.8 | dockerfile/alpine_3.9  |

Special builds:

| Docker tag        | Dockerfile              |
| ----------------- | ----------------------- |
| 2.10.0-centos7    | dockerfile/centos_7     |
| 2.10.0-ubuntu     | dockerfile/ubuntu_20.04 |
| 1.x-centos7       | dockerfile/centos_7     |
| 2.x-centos7       | dockerfile/centos_7     |

### Release policy

All images are pushed to [Docker Hub](docker_hub_tags).

Fixed version tags (`x.y.z`) are frozen: we never update them.

Example of versions timeline for Tarantool since 2.10
(see the [release policy](https://www.tarantool.io/en/doc/latest/release/policy/)):

- `2.10.0-beta1` — Beta
  - `2.10.0-rc1` — Release candidate
    - `2.10.0` — Release (stable)

Example of minor versions timeline for Tarantool up to 2.8:

- `x.y.0` - Alpha
  - `x.y.1` - Beta
    - `x.y.2` - Stable
      - `x.y.3` - Stable

Rolling versions are updated to the latest release (stable) versions:

- `x.y` == `x.y.latest-z` (`==` means 'points to the same image')
- `1` == `1.10.latest-z`
- `2` == `2.latest-y.z`
- `latest` == `2`

Special stable builds (CentOS) are updated with the same policy as rolling versions:

- `1.x-centos7` image offers a last `1.<last-y>.2` release
- `2.x-centos7` image offers a last `2.<last-y>.2` release

[docker_hub_tags]: https://hub.docker.com/r/tarantool/tarantool/tags

### Exceptional cases

As an exception we can deliver an important update for the existing tarantool
release within `x.y.z-r1`, `x.y.z-r2`, ... tags.

When `x.y.z-r<N>` is released, the corresponding rolling releases (`x.y`, `x`
and `latest` if `x` == 2) should be updated to point to the same image.

There is no strict policy, which updates should be considered important. Let's
decide on demand and define the policy later.

TBD: How to notify users about the exceptional updates?

### How to build and push an image

Example:

```console
$ export TAG=2
$ export OS=alpine DIST=3.9 VER=2.x  # double check the values!
$ PORT=5200 make -f .gitlab.mk build
$ docker push tarantool/tarantool:${TAG}
```
