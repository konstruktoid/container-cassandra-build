# Cassandra

Simple Cassandra lab using Docker.

_Please note that because of the changes to [Docker Automated Builds](https://docs.docker.com/docker-hub/builds/)
many Docker images are now outdated and a manual build is required and recommended._

```sh
$ docker build --no-cache -t konstruktoid/cassandra -f Dockerfile .
$ docker run -d --name cass01 --ulimit nproc=10000:10000 --ulimit nofile=10000:10000 konstruktoid/cassandra
$ docker logs -f cass01 2>/dev/null | grep -o 'Starting listening for CQL clients'
$ docker exec -ti cass01 cqlsh localhost
Connected to Test Cluster at localhost:9042
[cqlsh 6.0.0 | Cassandra 4.0.3 | CQL spec 3.4.5 | Native protocol v5]
Use HELP for help.
cqlsh> exit
$ docker exec -ti cass01 nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address    Load       Tokens  Owns (effective)  Host ID                               Rack
UN  127.0.0.1  69.08 KiB  16      100.0%            1aca53af-5c43-4adc-b3c3-bdfdf839e3cc  rack1
```
