#!/bin/bash
set -e

grafana_params="--homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana"

if [ -f /datasource.json.tpl ]; then
  envtpl /datasource.json.tpl

  /usr/share/grafana/bin/grafana-server ${grafana_params} &
  pid_grafana=$!

  grafana_ds_url="http://${API_USER}:${API_PASS}@${API_HOST}:${API_PORT}/api/datasources"

  until $(curl --output /dev/null --silent --get --fail ${grafana_ds_url}); do
    printf "waiting for grafana to start...\n"
    sleep 2
  done

  curl \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -X POST ${grafana_ds_url} \
    --output /dev/null --silent \
    --data @/datasource.json

  printf "added datasource from datasource.json to grafana...\n"

  kill -9 ${pid_grafana}
fi

/usr/share/grafana/bin/grafana-server ${grafana_params}
