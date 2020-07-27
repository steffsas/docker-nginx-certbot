#!/bin/sh

# check environment var
if [[ ! -n "${RELOAD_NGINX_FILE}" ]]; then
        echo "No environment variable set..."
        echo "Please have a look at your docker-compose.yml file and make sure you set the environment variable RELOAD_NGINX_FILE properly!"
        EXIT
fi

# check for reload
while sleep 5; do
        if [ -f "/etc/reload/${RELOAD_NGINX_FILE}" ]; then
                echo "Reload nginx triggered due to certificate change ...."
                nginx -s reload
                echo "Reload done!"
                rm "/etc/reload/${RELOAD_NGINX_FILE}"
        fi
done
