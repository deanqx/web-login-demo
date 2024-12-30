#!/bin/bash
set -e

openssl genpkey -algorithm RSA -out ca_key.pem
openssl req -new -x509 -key ca_key.pem -out ca_cert.pem -subj "/CN=RegistryCA"

openssl genpkey -algorithm RSA -out registry_key.pem
openssl req -new -key registry_key.pem -out registry.csr \
    -subj "/CN=registry.internal" \
    -addext "subjectAltName = DNS:registry.internal"

openssl x509 -req -in registry.csr -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial \
    -out registry_cert.pem -days 36500

rm registry.csr
