# Grafana Docker image

[![](https://badge.imagelayers.io/konjak/grafana:latest.svg)](https://imagelayers.io/?images=konjak/grafana:latest)

Production ready Docker container with the latest build of Grafana and datasource configuration via environment variables.
[grafana-influx-dashboard](https://github.com/anryko/grafana-influx-dashboard) is included in this image.
Furthermore 2 dashboards for monitoring the host and docker containers are added. These dashboards work with collectd metrics stored to an influxdb.
Consider using [docker-collectd](https://github.com/konstantinj/docker-collectd) which is prodviding host and docker metrics.

## Usage

All options defined in conf/grafana.ini can be overriden using environment variables.
You can automatically add a datasource configuration via environment variables, example:

```
docker run \
    -p 3000:3000 \
    -e "DS_NAME=datasource_name" \
    -e "DS_TYPE=datasource type (CloudWatch, Graphite, InfluxDB, etc...)" \
    -e "DS_ACCESS=proxy or direct" \
    -e "DS_URL=datasource url" \
    -e "DS_PASSWORD=password" \
    -e "DS_USER=user" \
    -e "DS_DATABASE=database" \
    -e "DS_IS_DEFAULT=true" \
    -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
    -e "GF_SECURITY_ADMIN_USER=admin" \
    -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
    -e "API_HOST=localhost" \
    -e "API_PORT=3000" \
    -e "API_USER=admin" \
    -e "API_PASS=secret" \
    konjak/grafana
```

## Status

Production stable.
