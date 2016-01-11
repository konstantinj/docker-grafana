#!/bin/bash
set -e

grafana_params="--homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini cfg:default.paths.data=/var/lib/grafana cfg:default.paths.logs=/var/log/grafana"

if [ -f /datasource.json.tpl ]; then
  envtpl /datasource.json.tpl

  /usr/sbin/grafana-server ${grafana_params} &
  pid_grafana=$!

  grafana_url="http://${API_USER}:${API_PASS}@${API_HOST}:${API_PORT}"
  grafana_ds_url="${grafana_url}/api/datasources"
  grafana_db_url="${grafana_url}/api/dashboards/db"

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

  curl \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -X POST ${grafana_db_url} \
    --output /dev/null --silent \
    --data @/dashboard.host.json

  curl \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -X POST ${grafana_db_url} \
    --output /dev/null --silent \
    --data @/dashboard.docker.json

  printf "added dashboards for dashboard.host.json and dashboard.docker.json to grafana...\n"

  kill -9 ${pid_grafana}

  sed -i '/^\[auth\.proxy\]$/,/^\[/ s/^;enabled = false/enabled = true/' /etc/grafana/grafana.ini
  sed -i '/^\[auth\.basic\]$/,/^\[/ s/^;enabled = true/enabled = false/' /etc/grafana/grafana.ini
fi

/usr/sbin/grafana-server ${grafana_params}
