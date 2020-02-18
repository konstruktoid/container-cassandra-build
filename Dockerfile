FROM konstruktoid/java

LABEL org.label-schema.name="cassandra" \
      org.label-schema.vcs-url="git://github.com/konstruktoid/Cassandra_Build.git"

ENV DIRS '/var/log/cassandra/ /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_cache'

RUN \
    apt-get update && \
    apt-get -y install ca-certificates curl gnupg procps --no-install-recommends && \
    curl -sSL https://www.apache.org/dist/cassandra/KEYS | apt-key add - && \
    echo 'deb http://www.apache.org/dist/cassandra/debian 311x main' | tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    mkdir -p $DIRS && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install cassandra cassandra-tools --no-install-recommends && \
    chown -R cassandra:cassandra $DIRS && \
    chmod -R 0755 $DIRS && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
      /usr/share/doc /usr/share/doc-base \
      /usr/share/man /usr/share/locale /usr/share/zoneinfo

EXPOSE 7000 7001 7199 9042 9160

COPY jvm.options /etc/cassandra/jvm.options

USER cassandra

CMD ["cassandra", "-f"]
