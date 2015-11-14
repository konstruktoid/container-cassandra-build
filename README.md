# Cassandra

Simple Cassandra lab using Docker.

```sh
$ docker build -t cassandra -f Dockerfile .
$ docker run -d --name cass01 --ulimit nproc=10000:10000 --ulimit nofile=10000:10000  cassandra
$ docker exec -ti cass01 nodetool info
ID                     : 4e02522e-0b53-42b3-af89-08f31bc82118
Gossip active          : true
Thrift active          : false
Native Transport active: true
Load                   : 96.95 KB
Generation No          : 1447421944
Uptime (seconds)       : 132
Heap Memory (MB)       : 55.37 / 990.00
Off Heap Memory (MB)   : 0.00
Data Center            : datacenter1
Rack                   : rack1
Exceptions             : 0
Key Cache              : entries 10, size 816 bytes, capacity 49 MB, 19 hits, 32 requests, 0.594 recent hit rate, 14400 save period in seconds
Row Cache              : entries 0, size 0 bytes, capacity 0 bytes, 0 hits, 0 requests, NaN recent hit rate, 0 save period in seconds
Counter Cache          : entries 0, size 0 bytes, capacity 24 MB, 0 hits, 0 requests, NaN recent hit rate, 7200 save period in seconds
Token                  : (invoke with -T/--tokens to see all 256 tokens)
$ docker exec -ti cass01 cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 2.2.3 | CQL spec 3.3.1 | Native protocol v4]
Use HELP for help.
cqlsh>
```
