FROM openshift/base-centos7

MAINTAINER Zak Hassan zak.hassan1010@gmail.com

RUN yum install -y curl wget unzip java-1.8.0-openjdk-devel.x86_64

RUN wget http://apache.mirror.gtcomm.net/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz && tar xvzf kafka_2.11-0.10.2.0.tgz -C /usr/local/  && rm kafka_2.11-0.10.2.0.tgz
RUN cd /usr/local &&  mv /usr/local/kafka_2.11-0.10.2.0/   /usr/local/kafka

ENV KAFKA_HOME /usr/local/kafka
COPY entrypoint.sh /etc/entrypoint.sh
COPY jolokia-jvm-1.3.4-agent.jar /usr/local/kafka/bin
COPY kafka-run-class.sh /usr/local/kafka/bin

RUN chown -Rv 1001:0 /usr/local/kafka && chmod -R ug+rwx /usr/local/kafka
COPY kafka.conf  /etc/security/limits.d/kafka.conf
COPY limits.conf /etc/security/limits.conf
#RUN sysctl -p
#curl 'http://localhost:9999/jolokia/' -XPOST -d '{"type":"read","mbean":"java.lang:type=Memory","attribute":"HeapMemoryUsage"}'
ENV JAVA_HOME   /usr/lib/jvm/java-1.8.0
ENV PATH $PATH:$KAFKA_HOME/bin

USER 1001

EXPOSE  9092 9999

ENTRYPOINT ["/etc/entrypoint.sh"]
