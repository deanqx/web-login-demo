#!/bin/bash
set -eu

echo "Create volume if not exists:"
sudo docker volume create registry_data

sudo docker stop registry 2>/dev/null || true
sudo docker rm registry 2>/dev/null || true

sudo docker run -d \
    -p 5000:5000 \
    -v ./.certs:/certs \
    -v registry_data:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.cert \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    -e REGISTRY_HTTP_TLS_CLIENTCAS=[/certs/ca.crt] \
    --name registry \
    --restart unless-stopped \
    registry:2

# This is default: -e REGISTRY_HTTP_TLS_CLIENTAUTH=require-and-verify-client-cert \

echo "Successful"
