# web-login-demo

A demo project about **Zero Downtime Deployment** with **Kubernetes**.

The guide generally made for Linux users.

### Frontend Version 1.0

### Backend Version 1.0

Format: [Major change].[Minor change]

Major changes break the compatibility between the frontend and backend.
They always have the same major number.

The version only needs to be updated when the code is shipped to production.

# Stack

## Frontend

- SvelteKit
- Scss

The website contains

[x] a login
[x] admins can create new users
[ ] admins can search and edit existing ones
[ ] an editable user profile with profile picture upload

## Backend

- Ingress Nginx
- Pheonix (Elixir)
- Postgres
- Docker
- Private Docker Registry
- Kubernetes
- NixOS

# Developing

Find guides in `frontend/README.md` and `backend/README.md`.

# First backend setup

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

```bash
kubectl get pods -n ingress-nginx
```

```bash
kubectl apply -f kubernetes/load_balancer.yaml
```

kubectl get ingress -n ingress-nginx --watch

To get IP on real server:

```bash
minikube service ingress-nginx-controller -n ingress-nginx
```

Debug:

```bash
kubectl describe ingress
```

```bash
kubectl get pods -n ingress-nginx
kubectl logs -n ingress-nginx <nginx-ingress-pod-name>
```

`/etc/hosts`

```bash
minikube service ingress-nginx-controller -n ingress-nginx
```

Use IP for http/80

```
192.x.x.x minikube.local
```

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

Follow the steps from [Get access to the Registry](###get-access-to-the-registry).

# Deploying

We use Kubernetes for the API and Web Service. The Database is run
with Docker Compose instead of Kubernetes:

```bash
docker compose up -d db
```

## Update Version

The api version number needs to be updated in:

- README.md
- backend/mix.exs
- kubernetes/api.yaml

The web version number needs to be updated in:

- README.md
- frontend/package.json
- kubernetes/web.yaml

## Testing with Docker Compose

```bash
docker compose build
docker compose up -d
```

## Upload image to Registry

This script builds and pushes the desired images to the Registry.
Don't forget to set the `registry.internal` host alias correctly,
if you want to [test it with Minikube](##testing-with-minikube).
Run script to get an usage example:

```bash
./scripts/publish.sh
```

## Testing with Minikube

For Linux users it is recommended to use KVM (Kernel-based Virtual Machine) over Virtualbox.
KVM requires that the virtual machine host's processor has
virtualization support (named VT-x for Intel processors and AMD-V for AMD processors).

```bash
minikube start
```

The Minikube needs to be set up like a Node.
Follow the guide about [setting up a Node](##setting-up-a-node).

## Rolling out update

⚠️ **Important:** Complete first step of [Database migration](##database-migration) first.

On the Control Plane server execute:

```bash
./scripts/rollout.sh kubernetes
```

-> Further debug commands can be found online.

## Database migration

1. Run `backend/priv/repo_migrations/{VERSION}_pre.sql`
2. [Roll out update](##rolling-out-update)
3. Run `backend/priv/repo_migrations/{VERSION}_post.sql`
   If this file does not exist, post migration is not needed.
