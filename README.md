# Cassandra

A single-node [Apache Cassandra](https://cassandra.apache.org/) 5.0 lab image,
built on `ubuntu:noble` with OpenJDK 17.

_Please note that because of the changes to
[Docker Automated Builds](https://docs.docker.com/docker-hub/builds/) many Docker
images are now outdated and a manual build is required and recommended._

## Build and run

```sh
$ podman build --no-cache -t konstruktoid/cassandra -f Dockerfile .
$ podman run -d --name cass01 konstruktoid/cassandra
$ podman logs -f cass01 2>/dev/null | grep -o 'Starting listening for CQL clients'
$ podman exec -ti cass01 cqlsh localhost
Connected to Test Cluster at localhost:9042
[cqlsh 6.2.0 | Cassandra 5.0.9 | CQL spec 3.4.7 | Native protocol v5]
Use HELP for help.
cqlsh> exit
$ podman exec -ti cass01 nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address    Load        Tokens  Owns (effective)  Host ID                               Rack
UN  127.0.0.1  114.71 KiB  16      100.0%            5f45db6e-90b9-4ef1-ae81-cda5e4a812f6  rack1
```

Cassandra needs a minute or two to come up. The `HEALTHCHECK` reports `healthy`
once `nodetool status` shows the node as `UN`, so `--health-*` or
`podman wait --condition healthy` is a reliable way to wait for it.

## The server only listens on localhost

The packaged `cassandra.yaml` sets both `listen_address` and `rpc_address` to
`localhost`. The `EXPOSE`d ports are therefore **only reachable from inside the
container**: publishing 9042 with `-p` gives you a host port that accepts the
connection and then drops it.

That is deliberate for a lab image with authentication left at
`AllowAllAuthenticator`. To reach it from outside, override the addresses and
put authentication in place first:

```sh
podman run -d --name cass01 -p 9042:9042 \
  -v ./cassandra.yaml:/etc/cassandra/cassandra.yaml:ro,Z \
  konstruktoid/cassandra
```

## Ports

| Port | Use |
| ---- | --- |
| 7000 | intra-node communication |
| 7001 | intra-node communication over TLS |
| 7199 | JMX |
| 9042 | CQL native transport |

## Notes

* The Apache archive key is installed to its own keyring under
  `/usr/share/keyrings` and bound to the Cassandra source with `signed-by`.
  `apt-key`, used previously, no longer exists in `noble`.
* `jvm.options` holds only settings that are valid on every supported JVM.
  Garbage collector and GC logging flags belong in the `jvm11-server.options`
  and `jvm17-server.options` files that the package ships, and putting them here
  stops the JVM from starting at all: the CMS options this file used to carry
  were removed from the JDK after version 8.
* Data lives in the `/var/lib/cassandra` volume and the server runs as the
  `cassandra` user.

## Development

`.pre-commit-config.yaml` runs gitleaks, hadolint, actionlint and
markdownlint:

```sh
pre-commit run --all-files
```
