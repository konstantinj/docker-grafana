FROM alpine:latest

MAINTAINER Konstantin Jakobi <konstantin.jakobi@gmail.com>

RUN export GRAFANA_VERSION=v2.6.0 \
 && export GOPATH=/go \
 && PATH=$PATH:$GOPATH/bin \
 && apk add -U build-base nodejs go git mercurial python py-pip curl wget bash \
 && mkdir -p /go/src/github.com/grafana && cd /go/src/github.com/grafana \
 && git clone https://github.com/grafana/grafana.git -b ${GRAFANA_VERSION} \
 && cd grafana \
 && go run build.go setup \
 && godep restore \
 && go build . \
 && npm install \
 && npm install -g grunt-cli \
 && cd /go/src/github.com/grafana/grafana/node_modules/karma-phantomjs-launcher/node_modules/phantomjs && node install \
 && cd /go/src/github.com/grafana/grafana && grunt \
 && npm uninstall -g grunt-cli \
 && npm cache clear \
 && mkdir -p /usr/share/grafana/bin/ \
 && cp -a /go/src/github.com/grafana/grafana/grafana /usr/share/grafana/bin/grafana-server \
 && cp -ra /go/src/github.com/grafana/grafana/public_gen /usr/share/grafana \
 && mv /usr/share/grafana/public_gen /usr/share/grafana/public \
 && cp -ra /go/src/github.com/grafana/grafana/conf /usr/share/grafana \
 && go clean -i -r \
 && apk del --purge build-base nodejs go git mercurial \
 && rm -rf /go /tmp/* /var/cache/apk/* /root/.n* /usr/local/bin/phantomjs

VOLUME ["/usr/share/grafana"]

EXPOSE 3000

COPY datasource.json.tpl /datasource.json.tpl
COPY run.sh /run.sh

RUN git clone --depth=1 https://github.com/anryko/grafana-influx-dashboard.git \
 && cd ./grafana-influx-dashboard \
 && ./install.sh /usr/share/grafana

CMD /run.sh
