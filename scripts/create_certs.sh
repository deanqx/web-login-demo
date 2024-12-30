#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage:   ./create_certs.sh [Output directory]"
    echo "Exmaple: ./create_certs.sh ./.certs"
    exit 1
fi

output=$1

# Create a Certificate Authority
openssl genrsa -out ${output}/ca.key 4096
openssl req -new -x509 -key ${output}/ca.key -out ${output}/ca.crt -subj "/CN=RegistryCA"

# Create the Server Certificate
openssl genrsa -out ${output}/registry.key 4096
openssl req -new -key ${output}/registry.key -config openssl.cnf -out ${output}/registry.csr
openssl req -x509 -in ${output}/registry.csr -CA ${output}/ca.crt -CAkey ${output}/ca.key \
    -copy_extensions copy -config openssl.cnf -out ${output}/registry.crt -days 36500

# Create the Client Certificate
openssl genrsa -out ${output}/node.key 4096
openssl req -new -key ${output}/node.key -out ${output}/node.csr -subj "/CN=RegistryAccess"
openssl req -x509 -in ${output}/node.csr -CA ${output}/ca.crt -CAkey ${output}/ca.key \
    -copy_extensions copy -out ${output}/node.crt -days 36500


rm ${output}/registry.csr
rm ${output}/node.csr
