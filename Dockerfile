FROM konstruktoid/java

ENV REPO 'deb http://debian.datastax.com/community stable main'

RUN \
    apt-get update && \
    apt-get -y install procps curl --no-install-recommends && \
    curl -L http://debian.datastax.com/debian/repo_key | apt-key add - && \
    echo $REPO > /etc/apt/sources.list.d/cassandra.sources.list

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install dsc22 cassandra-tools --no-install-recommends && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* \
    /usr/share/doc /usr/share/doc-base \
    /usr/share/man /usr/share/locale /usr/share/zoneinfo

EXPOSE 7000 7001 7199 9042 9160

CMD ["cassandra", "-f"]
