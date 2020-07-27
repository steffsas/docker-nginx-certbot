#!/bin/sh
# starting nginx
nginx -g 'daemon off;' & exec /scripts/check_reload.sh 
