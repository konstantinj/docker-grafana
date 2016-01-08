FROM debian:jessie

MAINTAINER Konstantin Jakobi <konstantin.jakobi@gmail.com>

ENV GRAFANA_VERSION 2.6.0

RUN apt-get update \
 && apt-get -y install libfontconfig wget adduser openssl ca-certificates python python-pip curl \
 && apt-get clean \
 && wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb -O /tmp/grafana.deb \
 && dpkg -i /tmp/grafana.deb \
 && rm /tmp/grafana.deb \
 && pip install envtpl

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY datasource.json.tpl /datasource.json.tpl
COPY run.sh /run.sh

CMD /run.sh
