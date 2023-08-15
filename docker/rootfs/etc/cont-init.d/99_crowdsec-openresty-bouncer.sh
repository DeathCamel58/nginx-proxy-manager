#!/usr/bin/with-contenv bash

#set -e # Exit immediately if a command exits with a non-zero status.
#set -u # Treat unset variables as an error.

log "Enabling CrowdSec OpenResty Bouncer"

sed -i "s/<LAPI_URL>/$LAPI_URL/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
sed -i "s/<API_KEY>/$LAPI_KEY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf