FROM ubuntu:noble@sha256:33ceb71981b602c1a7443a53469e4dba065f7503eab3078a2d7a57a2ab987517

LABEL org.opencontainers.image.title="cassandra" \
      org.opencontainers.image.description="Apache Cassandra 5.0 lab image" \
      org.opencontainers.image.authors="Thomas Sjögren <konstruktoid@users.noreply.github.com>" \
      org.opencontainers.image.source="https://github.com/konstruktoid/container-cassandra-build" \
      org.opencontainers.image.url="https://cassandra.apache.org/" \
      org.opencontainers.image.base.name="docker.io/library/ubuntu:noble"

ARG DEBIAN_FRONTEND=noninteractive
# Cassandra 5.0 is supported on JDK 11 and 17; 17 is the newer of the two.
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CASSANDRA_SERIES=50x

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# apt-key is removed in noble, so the archive key is written to its own keyring
# and bound to the Cassandra source with signed-by.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      openjdk-17-jre-headless \
      procps && \
    curl -fsSL https://downloads.apache.org/cassandra/KEYS | \
      gpg --dearmor -o /usr/share/keyrings/apache-cassandra.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/apache-cassandra.gpg] https://debian.cassandra.apache.org ${CASSANDRA_SERIES} main" \
      > /etc/apt/sources.list.d/cassandra.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends cassandra cassandra-tools && \
    apt-get -y purge curl gnupg && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
      /usr/share/doc /usr/share/doc-base \
      /usr/share/man /usr/share/locale /usr/share/zoneinfo

COPY jvm.options /etc/cassandra/jvm.options

# Each directory is created and chowned separately; a single space-separated
# variable would be one path with spaces in it, not four directories.
RUN mkdir -p \
      /var/log/cassandra \
      /var/lib/cassandra/data \
      /var/lib/cassandra/commitlog \
      /var/lib/cassandra/saved_caches && \
    chown -R cassandra:cassandra /var/log/cassandra /var/lib/cassandra /etc/cassandra && \
    chmod -R 0750 /var/log/cassandra /var/lib/cassandra

# 7000 intra-node, 7001 intra-node TLS, 7199 JMX, 9042 CQL.
# The packaged cassandra.yaml sets listen_address and rpc_address to localhost,
# so these ports are only reachable from inside the container until that is
# overridden. See the README.
EXPOSE 7000 7001 7199 9042

VOLUME ["/var/lib/cassandra"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=2m --retries=5 \
  CMD ["/bin/sh", "-c", "nodetool status | grep -q '^UN'"]

USER cassandra

CMD ["cassandra", "-f"]
