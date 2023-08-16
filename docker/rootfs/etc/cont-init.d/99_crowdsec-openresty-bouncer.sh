#!/command/with-contenv bash
# shellcheck shell=bash

#set -u # Treat unset variables as an error.

echo "Configuring CrowdSec OpenResty Bouncer"

# Change the LAPI variables in the config
echo "Setting LAPI_URL and API_KEY"
sed -i "s/<LAPI_URL>/http:\/\/$LAPI_URL/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
sed -i "s/<API_KEY>/$LAPI_KEY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf

# Check if BOUNCING_ON_TYPE is set
if [ -n "$BOUNCING_ON_TYPE" ]; then
  sed -i "s/BOUNCING_ON_TYPE=all/BOUNCING_ON_TYPE=$BOUNCING_ON_TYPE/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet BOUNCING_ON_TYPE"
fi

# Check if FALLBACK_REMEDIATION is set
if [ -n "$FALLBACK_REMEDIATION" ]; then
  sed -i "s/FALLBACK_REMEDIATION=ban/FALLBACK_REMEDIATION=$FALLBACK_REMEDIATION/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet FALLBACK_REMEDIATION"
fi

# Check if MODE is set
if [ -n "$MODE" ]; then
  sed -i "s/MODE=stream/MODE=$MODE/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet MODE"
fi

# Check if CACHE_EXPIRATION is set
if [ -n "$CACHE_EXPIRATION" ]; then
  sed -i "s/CACHE_EXPIRATION=1/CACHE_EXPIRATION=$CACHE_EXPIRATION/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet CACHE_EXPIRATION"
fi

# Check if UPDATE_FREQUENCY is set
if [ -n "$UPDATE_FREQUENCY" ]; then
  sed -i "s/UPDATE_FREQUENCY=10/UPDATE_FREQUENCY=$UPDATE_FREQUENCY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet UPDATE_FREQUENCY"
fi

# Check if RET_CODE is set
if [ -n "$RET_CODE" ]; then
  sed -i "s/RET_CODE=/RET_CODE=$RET_CODE/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet RET_CODE"
fi

# Check if BAN_TEMPLATE_PATH is set
if [ -n "$BAN_TEMPLATE_PATH" ]; then
  sed -i "s/BAN_TEMPLATE_PATH=/BAN_TEMPLATE_PATH=$BAN_TEMPLATE_PATH/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet BAN_TEMPLATE_PATH"
fi

# Check if CAPTCHA_PROVIDER is set
if [ -n "$CAPTCHA_PROVIDER" ]; then
  sed -i "s/CAPTCHA_PROVIDER=/CAPTCHA_PROVIDER=$CAPTCHA_PROVIDER/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
  echo "\tSet CAPTCHA_PROVIDER"

  # Check if SECRET_KEY is set
  if [ -n "$SECRET_KEY" ]; then
    sed -i "s/SECRET_KEY=/SECRET_KEY=$SECRET_KEY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
    echo "\tSet SECRET_KEY"
  else
    echo "\tSECRET_KEY is not set!"
  fi

  # Check if SITE_KEY is set
  if [ -n "$SITE_KEY" ]; then
    sed -i "s/SITE_KEY=/SITE_KEY=$SITE_KEY/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
    echo "\tSet SITE_KEY"
  else
    echo "\tSITE_KEY is not set!"
  fi

  # Check if CAPTCHA_EXPIRATION is set
  if [ -n "$CAPTCHA_EXPIRATION" ]; then
    sed -i "s/CAPTCHA_EXPIRATION=/CAPTCHA_EXPIRATION=$CAPTCHA_EXPIRATION/g" /etc/crowdsec/bouncers/crowdsec-openresty-bouncer.conf
    echo "\tSet CAPTCHA_EXPIRATION"
  else
    echo "\CAPTCHA_EXPIRATION is not set!"
  fi
else
  echo "\tCAPTCHA_PROVIDER is not set, no captcha support!";
fi