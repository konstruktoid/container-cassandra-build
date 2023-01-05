# Cassandra

Simple Cassandra lab using Docker.

_Please note that because of the changes to [Docker Automated Builds](https://docs.docker.com/docker-hub/builds/)
many Docker images are now outdated and a manual build is required and recommended._

```sh
$ podman build --no-cache -t konstruktoid/cassandra -f Dockerfile .
$ podman run -d --name cass01 konstruktoid/cassandra
$ podman logs -f cass01 2>/dev/null | grep -o 'Starting listening for CQL clients'
$ podman exec -ti cass01 cqlsh localhost
Connected to Test Cluster at localhost:9042
[cqlsh 6.1.0 | Cassandra 4.1.0 | CQL spec 3.4.6 | Native protocol v5]
Use HELP for help.
cqlsh> exit
$ podman exec -ti cass01 nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address    Load        Tokens  Owns (effective)  Host ID                               Rack
UN  127.0.0.1  104.34 KiB  16      100.0%            8a6ddc64-3f03-4791-a15d-41d3b2d1f982  rack1
```
