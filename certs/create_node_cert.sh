#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "The Hostname will look like this:"
    echo "Node name      Hostname"
    echo "node1       -> node1.internal"
    echo ""
    echo "Usage:   ./create_node_cert.sh [Certificates folder] [Node name]"
    echo "Example: ./create_node_cert.sh node1"
    exit 1
fi

mkdir $1 

file_prefix=${1}/${1}

openssl genpkey -algorithm RSA -out ${file_prefix}_key.pem
openssl req -new -key ${file_prefix}_key.pem -out ${file_prefix}.csr \
    -subj "/CN=${1}.internal" \
    -addext "subjectAltName = DNS:${1}.internal"

openssl x509 -req -in ${file_prefix}.csr -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial \
    -out ${file_prefix}_cert.pem -days 36500

rm ${file_prefix}.csr
cp ca_cert.pem ${output}
