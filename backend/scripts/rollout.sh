#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    echo "Usage:   ./rollout.sh [Config directory]"
    echo "Exmaple: ./rollout.sh ./kubernetes"
    exit 1
fi

kubectl create namespace web-login-demo 2>/dev/null && true

kubectl apply -f ${1}/api.yaml
kubectl apply -f ${1}/env-secret.yaml
kubectl apply -f ${1}/ingress.yaml
kubectl apply -f ${1}/web.yaml

echo

kubectl get ingress -n web-login-demo

echo

kubectl get all -n web-login-demo
