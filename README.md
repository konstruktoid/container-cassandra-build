# Cassandra

[![](https://images.microbadger.com/badges/image/konstruktoid/cassandra.svg)](https://microbadger.com/images/konstruktoid/cassandra "Cassandra")

Simple Cassandra lab using Docker.

```sh
$ docker build --no-cache -t konstruktoid/cassandra -f Dockerfile .
$ docker run -d --name cass01 --ulimit nproc=10000:10000 --ulimit nofile=10000:10000 konstruktoid/cassandra
$ docker logs cass01 2>/dev/null | grep -o 'Starting listening for CQL clients'
$ docker exec -ti cass01 cqlsh localhost
Connected to Test Cluster at localhost:9042.
[cqlsh 5.0.1 | Cassandra 3.11.6 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> HELP

Documented shell commands:
===========================
CAPTURE  CLS          COPY  DESCRIBE  EXPAND  LOGIN   SERIAL  SOURCE   UNICODE
CLEAR    CONSISTENCY  DESC  EXIT      HELP    PAGING  SHOW    TRACING

CQL help topics:
================
AGGREGATES               CREATE_KEYSPACE           DROP_TRIGGER      TEXT
ALTER_KEYSPACE           CREATE_MATERIALIZED_VIEW  DROP_TYPE         TIME
[...]
cqlsh>
```
