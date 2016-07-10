FROM docker.io/anapsix/docker-oracle-java8

MAINTAINER Zak Hassan zak.hassan1010@gmail.com

RUN wget http://apachemirror.ovidiudan.com/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz && tar xvzf kafka_2.11-0.9.0.1.tgz -C /usr/local/  && rm kafka_2.11-0.9.0.1.tgz

RUN cd /usr/local &&  mv /usr/local/kafka_2.11-0.9.0.1/   /usr/local/kafka
# && chown -Rv kafka /usr/local/kafka
# USER kafka

ENV KAFKA_HOME /usr/local/kafka
COPY entrypoint.sh /etc/entrypoint.sh

COPY kafka.conf  /etc/security/limits.d/kafka.conf
COPY limits.conf /etc/security/limits.conf
RUN sysctl -p

ENV PATH $PATH:$KAFKA_HOME/bin

EXPOSE  9092

ENTRYPOINT ["/etc/entrypoint.sh"]
