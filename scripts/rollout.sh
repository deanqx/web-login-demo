#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    echo "Usage:   ./rollout.sh [Config directory]"
    echo "Exmaple: ./rollout.sh ./kubernetes"
    exit 1
fi

kubectl apply -f ${1}/config.yaml
kubectl apply -f ${1}/secret.yaml
kubectl apply -f ${1}/api.yaml
kubectl apply -f ${1}/web.yaml
kubectl apply -f ${1}/load_balancer.yaml

echo

kubectl get pods -n ingress-nginx

echo

kubectl get pods
