#!/bin/bash

# Fail hard and fast
set -eo pipefail

export ETCD_PORT=${ETCD_PORT:-4001}
#export HOST_IP=${HOST_IP:-172.17.42.1}
export HOST_IP=${HOST_IP:-172.17.8.101}
export ETCD=$HOST_IP:4001

echo "[nginx] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/nginx.toml -verbose; do
  echo "[nginx] waiting for confd to refresh nginx.conf"
  sleep 5
done

cat /etc/nginx/sites-enabled/global.conf

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD -config-file /etc/confd/conf.d/nginx.toml -verbose &
echo "[nginx] confd is listening for changes on etcd..."

# Start nginx
echo "[nginx] starting nginx service..."
service nginx start

echo "--"
cat /etc/nginx/sites-enabled/global.conf

# Tail all nginx log files
tail -f /var/log/nginx/*.log
