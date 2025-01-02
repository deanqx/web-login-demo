# web-login-demo

A demo project about **Zero Downtime Deployment** with **Kubernetes**.

This guide generally made for Linux users.

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

- [x] a login
- [x] admins can create new users
- [ ] admins can search and edit existing ones
- [ ] an editable user profile with profile picture upload

## Backend

- Ingress Nginx
- Pheonix (Elixir)
- Postgres
- Docker
- Private Docker Registry
- Kubernetes
- NixOS

# Developing

- [Frontend](frontend/README.md)
- [Backend API](backend/api/README.md)
- [Setting up backend server](backend/README.md)

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

## Upload new version to Registry

This script builds and pushes the desired images to the Registry.
Don't forget to set the `registry.internal` host alias correctly,
if you want to [test it with Minikube](#testing-with-minikube).
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
Follow the guide about [setting up a Node](#setting-up-a-node).

## Rolling out update

⚠️ **Important:** Complete first step of [Database migration](#database-migration) first.

On the Control Plane server execute:

```bash
./rollout.sh kubernetes
```

## Debug Kubernetes

Use `web-login-demo` as default namespace.

```bash
kubectl config set-context --current --namespace=web-login-demo
```

-> Further debug commands can be found online.

## Database migration

1. Run `backend/priv/repo_migrations/{VERSION}_pre.sql`.
2. [Roll out update](#rolling-out-update) with Kubernetes.
3. Run `backend/priv/repo_migrations/{VERSION}_post.sql`.
   If this file does not exist, post migration is not needed.
