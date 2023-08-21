#!/command/with-contenv bash
# shellcheck shell=bash

set -e

. /bin/common.sh

log_info 'Checking paths ...'

# Ensure /data is mounted
if [ ! -d '/data' ]; then
	log_fatal '/data is not mounted! Check your docker configuration.'
fi

# Create required folders
mkdir -p \
	/data/logs \
	/data/nginx \
	/run/nginx \
	/tmp/nginx/body \
	/var/log/nginx \
	/var/lib/nginx/cache/public \
	/var/lib/nginx/cache/private \
	/var/cache/nginx/proxy_temp

touch /var/log/nginx/error.log || true
chmod 777 /var/log/nginx/error.log || true
chmod -R 777 /var/cache/nginx || true
chmod 644 /etc/logrotate.d/nginx-proxy-manager
