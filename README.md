<p align="center">
	<img src="https://nginxproxymanager.com/github.png">
	<br><br>
	<img src="https://img.shields.io/badge/version-2.9.19-green.svg?style=for-the-badge">
	<a href="https://hub.docker.com/repository/docker/jc21/nginx-proxy-manager">
		<img src="https://img.shields.io/docker/stars/jc21/nginx-proxy-manager.svg?style=for-the-badge">
	</a>
	<a href="https://hub.docker.com/repository/docker/jc21/nginx-proxy-manager">
		<img src="https://img.shields.io/docker/pulls/jc21/nginx-proxy-manager.svg?style=for-the-badge">
	</a>
</p>

This project comes as a pre-built docker image that enables you to easily forward to your websites
running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.

The original project has been modified to use CrowdSec as a bouncer.

- [Quick Setup](#quick-setup)
- [Full Setup](https://nginxproxymanager.com/setup/)
- [Screenshots](https://nginxproxymanager.com/screenshots/)

## Project Goal

I created this project to fill a personal need to provide users with a easy way to accomplish reverse
proxying hosts with SSL termination and it had to be so easy that a monkey could do it. This goal hasn't changed.
While there might be advanced options they are optional and the project should be as simple as possible
so that the barrier for entry here is low.

<a href="https://www.buymeacoffee.com/jc21" target="_blank"><img src="http://public.jc21.com/github/by-me-a-coffee.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>


## Features

- Beautiful and Secure Admin Interface based on [Chakra UI](https://chakra-ui.com/)
- Easily create forwarding domains, redirections, streams and 404 hosts without knowing anything about Nginx
- Free SSL using Let's Encrypt or provide your own custom SSL certificates
- Access Lists and basic HTTP Authentication for your hosts
- Advanced Nginx configuration available for super users
- User management, permissions and audit log


## Hosting your home network

I won't go in to too much detail here but here are the basics for someone new to this self-hosted world.

1. Your home router will have a Port Forwarding section somewhere. Log in and find it
2. Add port forwarding for port 80 and 443 to the server hosting this project
3. Configure your domain name details to point to your home, either with a static ip or a service like DuckDNS or [Amazon Route53](https://github.com/jc21/route53-ddns)
4. Use the Nginx Proxy Manager as your gateway to forward to your other web based services


## Quickest Setup

1. Install Docker and Docker-Compose

- [Docker Install documentation](https://docs.docker.com/install/)
- [Docker-Compose Install documentation](https://docs.docker.com/compose/install/)

2. Create a docker-compose.yml file similar to this:

```yml
version: '3.8'
services:
  # The nginx reverse proxy
  nginx:
    image: 'deathcamel57/nginx-proxy-manager:v3'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
      # Add any other Stream port you want to expose
      # - '21:21' # FTP

    environment:
      # CrowdSec CAPTCHA options
      CAPTCHA_PROVIDER: "recaptcha"
      SECRET_KEY: "===SECRET_KEY==="
      SITE_KEY: "===SITE_KEY==="
      CAPTCHA_EXPIRATION: "1800"

      # OpenResty Config
      LAPI_URL: "crowdsec:8080"
      LAPI_KEY: "b02ed1cd-5bad-4b02-b8ea-725e28699112"

      # General stuff
      TZ: "America/New_York"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

  # Crowdsec, for security
  crowdsec:
    image: crowdsecurity/crowdsec
    restart: always
    environment:
      #this is the list of collections we want to install
      #https://hub.crowdsec.net/author/crowdsecurity/collections/nginx
      COLLECTIONS: "crowdsecurity/nginx"

      # Crowdsec console registration
      ENROLL_KEY: "===CROWDSEC_ENROLL_KEY==="
      ENROLL_INSTANCE_NAME: "NPM_Docker"

      # CrowdSec bouncer registration
      BOUNCER_KEY_nginx: "b02ed1cd-5bad-4b02-b8ea-725e28699112"

      # General stuff
      TZ: "America/New_York"
      GID: "${GID-1000}"
    depends_on:
      - 'nginx'
    volumes:
      - crowdsec_data:/var/lib/crowdsec/data/
      - ./crowdsec-config:/etc/crowdsec/
      # Mount the acquisition parsers folder
      # Note: These files will have to be manually created!
      - ./crowdsec/acquis.d:/etc/crowdsec/acquis.d/
      # Mount log files needed
      - ./data/logs:/var/log/nginx

volumes:
  crowdsec_data:
```

This is a known working configuration, pulled from a live environment.
See the [documentation](https://nginxproxymanager.com/setup/) for more nginx proxy manager settings.
See the [documentation](https://hub.docker.com/r/crowdsecurity/crowdsec) for more CrowdSec settings.

3. Bring up your stack by running

```bash
docker-compose up -d

# If using docker-compose-plugin
docker compose up -d
```

4. Log in to the Admin UI

When your docker container is running, connect to it on port `81` for the admin interface.

[http://127.0.0.1:81](http://127.0.0.1:81)
# Additional configuration
| `crowdsec` environment option | description                                                                                                                                                              |
|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ENROLL_KEY`                  | The enroll key from the CrowdSec hub                                                                                                                                     |
| `ENROLL_INSTANCE_NAME`        | The name to send to CrowdSec hub                                                                                                                                         |
| `BOUNCING_ON_TYPE`            | Type of remediation we want to bounce. If you choose `ban` only and receive a decision with `captcha` as remediation, the bouncer will skip the decision.                |
| `FALLBACK_REMEDIATION`        | The fallback remediation is applied if the bouncer receives a decision with an unknown remediation.                                                                      |
| `MODE`                        | The bouncer mode                                                                                                                                                         |
| `REQUEST_TIMEOUT`             | Timeout in milliseconds for the HTTP requests done by the bouncer to query CrowdSec local API or captcha provider (for the captcha verification).                        |
| `CACHE_EXPIRATION`            | The cache expiration, in second, for IPs that the bouncer store in cache in `live` mode.                                                                                 |
| `UPDATE_FREQUENCY`            | The frequency of update, in second, to pull new/old IPs from the CrowdSec local API.                                                                                     |
| `RET_CODE`                    | The HTTP code to return for IPs that trigger a ban remediation. If nothing specified, it will return a `403`.                                                            |
| `CAPTCHA_PROVIDER`            | The CAPTCHA provider. `recaptcha`, `hcaptcha`, or `turnstile`                                                                                                            |
| `SECRET_KEY`                  | The captcha secret key.                                                                                                                                                  |
| `SITE_KEY`                    | The captcha site key.                                                                                                                                                    |
| `CAPTCHA_EXPIRATION`          | The time for which the captcha will be validated. After this duration, if the decision is still present in CrowdSec local API, the IPs address will get a captcha again. |

## Contributors

Special thanks to [all of our contributors](https://github.com/NginxProxyManager/nginx-proxy-manager/graphs/contributors).

## Getting Support

1. [Found a bug?](https://github.com/NginxProxyManager/nginx-proxy-manager/issues)
2. [Discussions](https://github.com/NginxProxyManager/nginx-proxy-manager/discussions)
3. [Development Gitter](https://gitter.im/nginx-proxy-manager/community)
4. [Reddit](https://reddit.com/r/nginxproxymanager)

## Become a Contributor

A guide to setting up your own development environment [is found here](DEV-README.md).
