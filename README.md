Apache Kafka on Docker
==========

In this repository you will find a docker file which will allow for running apache kakfa inside docker containers or inside kubernetes.


##Pull the image from Docker Repository
```
docker pull bzcareer/docker-kafka
```

## Building the image
Navigate to the bin directory and run
```
cd bin
./make-all.sh
```

or via docker commands:

```
docker build --rm -t bzcareer/docker-kafka .
```
## Environment Variables

### `KF_ID`
  * Required for clustered kafka. Must be unique
  * Defaults to 1

   ```
   -e "KF_ID=1"
   ```

### `KF_DATA_DIR`
  * Required for clustered kafka. Must be unique
  * Defaults to '/tmp/kafka.log'

   ```
   -e "KF_DATA_DIR=/tmp/broker.log"
   ```

### `ZK_KAFKA_URLS`
    * Required for clustered kafka. Must be comma separated see the following example:
     `127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002`
    * Defaults to localhost:2181 and starts and embedded zookeeper server.

     ```
     -e "ZK_KAFKA_URLS=172.30.143.165:2181,172.30.143.166:2181,172.30.143.167:2181"
     ```

## Running the image in docker standalone

* if using boot2docker make sure your VM has more than 2GB memory
for single standalone mode:
```
 docker run   -it -P  --hostname kafka.hadoopdata.com   bzcareer/docker-kafka
```
or for clustermode:

1. Start zookeeper in docker container
```
docker run   -it -P  --hostname zookeeper.hadoopdata.com   bzcareer/docker-zookeeper
```
2. Get the ip address of the zookeeper instance then pass it in with the port $<IP>:2181 as the environment variable ZK_KAFKA_URLS:
```

[vagrant@localhost ~]$ oc get services
NAME      CLUSTER-IP       EXTERNAL-IP   PORT(S)                                        AGE
kafka-d   172.30.165.151                 2181/TCP,2888/TCP,3888/TCP,8080/TCP,9092/TCP   7m
```
3. Go ahead and pass in the ip address plus port zookeeper is running on so kafka can connect to it.

```
 docker run   -e "ZK_KAFKA_URLS=172.30.165.151:2181" -e "KF_ID=1" -it -P  --hostname kafka.hadoopdata.com   bzcareer/docker-kafka
```

Note: If you are on kubernetes/openshift origin then make sure you created your kubernetes services which zookeeper will try to connect to.


## Running on Kubernetes or OpenShift Origin V3

To speed things up a bit pull down the docker image from dockerhub:
```
[ zak@localhost ] $ vagrant up
[ zak@localhost ] $ vagrant ssh default
```
Once your in the vm:
```
[ vagrant@localhost] oc login
                     username: admin
                    password: password
```

```
[ vagrant@localhost] $ oc new-project cloudanalytics
Now using project "cloudcassandra" on server "https://10.2.2.2:8443".
...
[ vagrant@localhost] $ docker pull bzcareer/docker-zookeeper
[ vagrant@localhost] $ docker pull bzcareer/docker-kafka
[ vagrant@localhost] $ git clone https://github.com/BZCareer/docker-kafka.git
[ vagrant@localhost] $ cd docker-kafka/kubernetes-demo/
[ vagrant@localhost] $ oc create -f kafka.pod.json
[ vagrant@localhost] $ oc create -f kafka.service.json
```


## This Example Should Not Be Used In Production

This is just an experiment so I hope you do not use in production.

## Versions
```
Apache Zookeeper v3.5.0 and Apache Kafka v0.9.0.1  on Ubuntu with Java 8
```
