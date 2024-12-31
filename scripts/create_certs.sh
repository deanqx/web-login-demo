#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage:   ./create_certs.sh [Output directory]"
    echo "Exmaple: ./create_certs.sh ./.certs"
    exit 1
fi

script_path=$(dirname "$(realpath "$0")")

mkdir -p $1

# Create a Certificate Authority
openssl genrsa -out ${1}/ca.key 4096
openssl req -new -x509 -key ${1}/ca.key -out ${1}/ca.crt -subj "/CN=RegistryCA"

# Create the Server Certificate
openssl genrsa -out ${1}/registry.key 4096
openssl req -new -key ${1}/registry.key -config ${script_path}/openssl.cnf -out ${1}/registry.csr
openssl req -x509 -in ${1}/registry.csr -CA ${1}/ca.crt -CAkey ${1}/ca.key \
    -copy_extensions copy -config ${script_path}/openssl.cnf -out ${1}/registry.cert -days 36500

# Create the Client Certificate
openssl genrsa -out ${1}/node.key 4096
openssl req -new -key ${1}/node.key -out ${1}/node.csr -subj "/CN=RegistryAccess"
openssl req -x509 -in ${1}/node.csr -CA ${1}/ca.crt -CAkey ${1}/ca.key \
    -copy_extensions copy -out ${1}/node.cert -days 36500

rm ${1}/registry.csr
rm ${1}/node.csr

echo "Successful"
