#!/bin/bash
set -eu

source .env

echo "DATABASE_URL: $(echo ecto://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}/${POSTGRES_DB} | base64)"

echo "SECRET_KEY_BASE: $(openssl rand -base64 48 | base64)"
