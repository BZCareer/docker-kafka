#!/bin/bash
# Author: Zak Hassan

# Standalone :
#     - env variables required: none
# Cluster mode:
#     - env variables required: $KF_ID, $KF_DATA_DIR, ZK_KAFKA_URLS (should be the ip address of the kubernetes service
#       each zk node should run independent in its own pod.)


cat << EOF > /usr/local/kafka/config/server.properties
broker.id=${KF_ID:=1}
port=9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=${KF_DATA_DIR:=/tmp/kafka.log}
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=false
zookeeper.connect=${ZK_KAFKA_URLS:=localhost:2181}
zookeeper.connection.timeout.ms=6000
EOF

if [ -z "$ZK_KAFKA_URLS" ]; then
        # if ZK doesn't exist external from this container we can start one in the container :)
        /usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties > /dev/null 2>&1 &
        sleep 2
fi
# Starting kafka inside this container
/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties
