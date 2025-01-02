#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    echo "Usage:   ./gen_backend_keys.sh [IP of Database host]"
    echo "Exmaple: ./gen_backend_keys.sh 192.168.11.52:5432"
    exit 1
fi

source .env

echo "DATABASE_URL: $(echo -n ecto://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${1}/${POSTGRES_DB} | base64)"

echo "SECRET_KEY_BASE: $(openssl rand -base64 48 | base64)"
