#!/bin/sh
# check every second hour
while sleep 7200; do 
	echo "Trigger certbot renewal certificate...";
	certbot renew --noninteractive --no-random-sleep-on-renew

	# create nginx reload files
	if [[ -n "${RELOAD_NGINX_FILES}" ]]; then
		echo "Creating reload files..."
		for file in ${RELOAD_NGINX_FILES}; do
			touch "/etc/reload/$file"
			echo "Reload file /etc/reload/$file created..."
		done
	fi
done
