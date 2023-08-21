#!/command/with-contenv bash
# shellcheck shell=bash

set -u # Treat unset variables as an error.

. /bin/common.sh

log_info "Fix for NPM v3 ACME.sh issue"

# Install acme.sh
ACMESH_SCRIPT=/data/.acme.sh/acme.sh
if ! [ -f "$ACMESH_SCRIPT" ]; then
	log_info "$ACMESH_SCRIPT does not exist, installing acme.sh ..."
  curl https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh | sh -s -- --install-online --no-cron --no-profile --force --home "$ACMESH_HOME" --cert-home "$CERT_HOME" --config-home "$ACMESH_CONFIG_HOME"
fi
