# TimescaleDB

TimescaleDB is an open-source database designed to make SQL scalable for time-series data. It is engineered up from PostgreSQL and packaged as a PostgreSQL extension, providing automatic partitioning across time and space (partitioning key), as well as full SQL support.

[GitHub: TimescaleDB](https://github.com/timescale/timescaledb)

## What is PostgreSQL?

PostgreSQL, often simply "Postgres", is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards-compliance. As a database server, its primary function is to store data, securely and supporting best practices, and retrieve it later, as requested by other software applications, be it those on the same computer or those running on another computer across a network (including the Internet). It can handle workloads ranging from small single-machine applications to large Internet-facing applications with many concurrent users. Recent versions also provide replication of the database itself for security and scalability.

PostgreSQL implements the majority of the SQL:2011 standard, is ACID-compliant and transactional (including most DDL statements) avoiding locking issues using multiversion concurrency control (MVCC), provides immunity to dirty reads and full serializability; handles complex SQL queries using many indexing methods that are not available in other databases; has updateable views and materialized views, triggers, foreign keys; supports functions and stored procedures, and other expandability, and has a large number of extensions written by third parties. In addition to the possibility of working with the major proprietary and open source databases, PostgreSQL supports migration from them, by its extensive standard SQL support and available migration tools. And if proprietary extensions had been used, by its extensibility that can emulate many through some built-in and third-party open source compatibility extensions, such as for Oracle.

![PosgreSQL Logo](./img/postgresql.png)

## How to Use this Image

This image is based on the official Postgres Docker image so the documentation for that image also applies here, including the environment variables one can set, extensibility, etc.

### Starting a TimescaleDB instance

```bash
$ docker run -d --name some-timescaledb -p 5432:5432 timescale/timescaledb:latest-pg13
```

Then connect with an app or the `psql` client:

```bash
$ docker run -it --net=host --rm timescale/timescaledb:latest-pg13 psql -h localhost -U postgres
```

You can also connect your app via port `5432` on the host machine.

If you are running your Docker image for the first time, you can also set an environmental variable, `TIMESCALEDB_TELEMETRY`, to set the level of telemetry in the Timescale Docker instance. For example, to turn off telemetry, run:

```bash
$ docker run -d --name some-timescaledb -p 5432:5432 --env TIMESCALEDB_TELEMETRY=off timescale/timescaledb:latest-pg13
```

Note that if the cluster has previously been initialized, you should not use this environment variable to set the level of telemetry. Instead, follow the instructions in our docs to disable telemetry once a cluster is running.

If you are interested in the latest development snapshot of timescaledb there is also a nightly build available under `timescaledev/timescaledb:nightly-pg13` (for PG 12, 13 and 14).

## How to Extend this Image

There are many ways to extend the Postgres image. Without trying to support every possible use case, here are just a few that we have found useful.

### Environment Variables

The PostgreSQL image uses several environment variables which are easy to miss. The only variable required is `POSTGRES_PASSWORD`, the rest are optional.

Warning: the Docker specific variables will only have an effect if you start the container with a data directory that is empty; any pre-existing database will be left untouched on container startup.

#### `POSTGRES_PASSWORD`

This environment variable is required for you to use the PostgreSQL image. It must not be empty or undefined. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable.

> **Note 1**: The PostgreSQL image sets up trust authentication locally so you may notice a password is not required when connecting from localhost (inside the same container). However, a password will be required if connecting from a different host/container.

> **Note 2**: This variable defines the superuser password in the PostgreSQL instance, as set by the initdb script during initial container startup. It has no effect on the `PGPASSWORD` environment variable that may be used by the psql client at runtime, as described at https://www.postgresql.org/docs/14/libpq-envars.html. `PGPASSWORD`, if used, will be specified as a separate environment variable.

#### `POSTGRES_USER`

This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of Postgres will be used.

Be aware that if this parameter is specified, PostgreSQL will still show The files belonging to this database system will be owned by user "postgres" during initialization. This refers to the Linux system user (from `/etc/passwd` in the image) that the Postgres daemon runs as, and as such is unrelated to the `POSTGRES_USER` option. See the section titled "Arbitrary --user Notes" for more details.

#### `POSTGRES_DB`

This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, then the value of `POSTGRES_USER` will be used.

#### `POSTGRES_INITDB_ARGS`

This optional environment variable can be used to send arguments to Postgres initdb. The value is a space separated string of arguments as Postgres initdb would expect them. This is useful for adding functionality like data page checksums: `-e POSTGRES_INITDB_ARGS="--data-checksums"`.

#### `POSTGRES_INITDB_WALDIR`

This optional environment variable can be used to define another location for the Postgres transaction log. By default the transaction log is stored in a subdirectory of the main Postgres data folder (`PGDATA`). Sometimes it can be desireable to store the transaction log in a different directory which may be backed by storage with different performance or reliability characteristics.

> **Note**: on PostgreSQL 9.x, this variable is `POSTGRES_INITDB_XLOGDIR` (reflecting the changed name of the `--xlogdir` flag to `--waldir` in PostgreSQL 10+).

#### POSTGRES_HOST_AUTH_METHOD

This optional variable can be used to control the auth-method for host connections for all databases, all users, and all addresses. If unspecified then scram-sha-256 password authentication is used (in 14+; md5 in older releases). On an uninitialized database, this will populate pg_hba.conf via this approximate line:

```bash
echo "host all all all $POSTGRES_HOST_AUTH_METHOD" >> pg_hba.conf
```

See the PostgreSQL documentation on pg_hba.conf for more information about possible values and their meanings.

> **Note 1**: It is not recommended to use trust since it allows anyone to connect without a password, even if one is set (like via POSTGRES_PASSWORD). For more information see the PostgreSQL documentation on Trust Authentication.

> **Note 2**: If you set `POSTGRES_HOST_AUTH_METHOD` to trust, then `POSTGRES_PASSWORD` is not required.

> **Note 3**: If you set this to an alternative value (such as scram-sha-256), you might need additional `POSTGRES_INITDB_ARGS` for the database to initialize correctly (such as `POSTGRES_INITDB_ARGS=--auth-host=scram-sha-256`).

#### PGDATA

> **Important Note**: when mounting a volume to `/var/lib/postgresql`, the `/var/lib/postgresql/data` path is a local volume from the container runtime, thus data is not persisted on the mounted volume.

This optional variable can be used to define another location - like a subdirectory - for the database files. The default is `/var/lib/postgresql/data`. If the data volume you're using is a filesystem mountpoint (like with GCE persistent disks), or remote folder that cannot be chowned to the postgres user (like some NFS mounts), or contains folders/files (e.g. lost+found), Postgres initdb requires a subdirectory to be created within the mountpoint to contain the data.

For example:

```bash
$ docker run -d \
	--name some-postgres \
	-e POSTGRES_PASSWORD=mysecretpassword \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /custom/mount:/var/lib/postgresql/data \
	postgres
```

This is an environment variable that is not Docker specific. Because the variable is used by the Postgres server binary (see the PostgreSQL docs), the entrypoint script takes it into account.

## Notes on `timescaledb-tune`

`timescaledb-tune` is run automatically on container initialization. By default, `timescaledb-tune` uses system calls to retrieve an instance's available CPU and memory. In docker images, these system calls reflect the available resources on the host. For cases where a container is allocated all available resources on a host, this is fine. But many use cases involve limiting the amount of resources a container (or the Docker daemon) can have on the host. Therefore, this image looks in the cgroups metadata to determine the Docker-defined limit sizes then passes those values to `timescaledb-tune`.

To specify your own limits, use the `TS_TUNE_MEMORY` and `TS_TUNE_NUM_CPUS` environment variables at runtime:

```bash
$ docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password -e TS_TUNE_MEMORY=4GB -e TS_TUNE_NUM_CPUS=4 timescale/timescaledb:latest-pg13
```

To specify a maximum number of background workers, use the TS_TUNE_MAX_BG_WORKERS environment variable:

```bash
$ docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password -e TS_TUNE_MAX_BG_WORKERS=16 timescale/timescaledb:latest-pg13
```

To specify a maximum number of connections, use the `TS_TUNE_MAX_CONNS` environment variable:

```bash
$ docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password -e TS_TUNE_MAX_CONNS=200 timescale/timescaledb:latest-pg13
```

To not run timescaledb-tune at all, use the `NO_TS_TUNE` environment variable:

```bash
$ docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password -e NO_TS_TUNE=true timescale/timescaledb:latest-pg13
```
