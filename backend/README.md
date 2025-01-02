# First backend setup

## Generating backend keys

The current secrets keys and passwords are not kept in Production.
The Git Repository should never contain any secrets.

```bash
./scripts/gen_backend_keys.sh
```

Update these values in `kubernetes/secret.yaml` after `data:`.

## Setting up Registry

### Generating Registry keys

The Registry uses mTLS to authorize the client.

- `ca.crt`: Public
- `ca.key`: Private
- `node.cert`: Gives access to Registry
- `node.key`: Gives access to Registry
- `node_certs.tar.gz`: Contains everything needed for a Node
- `registry.cert`: Private
- `registry.key`: Private

```bash
./scripts/gen_certs.sh .certs
```

### Start Registry server

This script both starts and restarts the Registry:

```bash
./scripts/restart_registry.sh
```

### Get access to the Registry

To upload Docker Images to the Registry there has to be a host alias
from `registry.internal` to the Registry server IP. The Port is set to `5000`.

1. Create or edit the file at `/etc/hosts` and insert the IP of the Registry server:

```
192.x.x.x registry.internal
```

2. Copy certificates and provide them for Docker.

```bash
mkdir --parents /etc/docker/certs.d/registry.internal:5000
cp .certs/ca.crt .certs/node.cert .certs/node.key /etc/docker/certs.d/registry.internal:5000
```

3. Test mTLS handshake

```bash
docker login registry.internal:5000
```

## Load balancer (Ingress Nginx)

The load balancer is a seperate Pod in the `ingress-nginx` namespace. To install and active it use:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

Verify status with:

```bash
kubectl get pods -n ingress-nginx
```

### Find out where to connect

```bash
minikube service ingress-nginx-controller -n ingress-nginx
```

## Setting up a Node

The Node needs access to the Registry. Send the `.certs/node_certs.tar.gz` with SCP (SSH).
It contains all required certificates.

To setup a Minikube use:

```bash
scp -i ~/.minikube/machines/minikube/id_rsa .certs/node_certs.tar.gz docker@$(minikube ip):/home/docker/
minikube ssh
```

```bash
tar -xzvf node_certs.tar.gz
```

Follow the steps from [Get access to the Registry](#get-access-to-the-registry).
