#!/bin/bash
set -eu

envsubst '${API_HOST}' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

exec "$@"
