FROM openshift/base-centos7

MAINTAINER Zak Hassan zak.hassan1010@gmail.com

RUN yum install -y curl wget unzip java-1.8.0-openjdk-devel.x86_64

RUN wget http://apachemirror.ovidiudan.com/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz && tar xvzf kafka_2.11-0.9.0.1.tgz -C /usr/local/  && rm kafka_2.11-0.9.0.1.tgz

RUN cd /usr/local &&  mv /usr/local/kafka_2.11-0.9.0.1/   /usr/local/kafka && chown -Rv 1001:0 /usr/local/kafka && chmod -R ug+rwx /usr/local/kafka

ENV KAFKA_HOME /usr/local/kafka
COPY entrypoint.sh /etc/entrypoint.sh

COPY kafka.conf  /etc/security/limits.d/kafka.conf
COPY limits.conf /etc/security/limits.conf
#RUN sysctl -p

ENV JAVA_HOME   /usr/lib/jvm/java-1.8.0
ENV PATH $PATH:$KAFKA_HOME/bin

USER 1001

EXPOSE  9092

ENTRYPOINT ["/etc/entrypoint.sh"]
