#!/command/with-contenv bash
# shellcheck shell=bash

set -u # Treat unset variables as an error.

echo 'Enabling CrowdSec OpenResty Bouncer'

# Change the LAPI variables in the config
sed -i "s/<LAPI_URL>/http:\/\/$LAPI_URL/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
sed -i "s/<API_KEY>/$LAPI_KEY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf