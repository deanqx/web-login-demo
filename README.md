# web-login-demo

A demo project about Zero Downtime Deployment.

## Frontend Version 1.0

## Backend Version 1.0

Format: [Major change].[Minor change]

Major changes do break the compatibility between the Frontend and Backend.
They always have the same major version.

The version only needs to be updated when the code is shipped to production.

# Stack

## Frontend

- Sveltekit
- Scss
- Bootstrap

The website contains

- a login
- an admin interface to create new users and edit old ones
- an editable user profile with profile picture upload

## Backend

- Pheonix (Elixir)
- Postgres
- NixOS
- Docker
- Kubernetes

# Deploying

We use Kubernetes for the API and Web Service.

The Database is run with Docker Compose instead of Kubernetes:

```bash
docker compose up -d db
```

## Versioning

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

## Testing with Minikube

Build Docker images and save as archives:

```bash
sudo ./publish.sh [Version] both
```

For Linux users it is recommended to use KVM (Kernel-based Virtual Machine) over Virtualbox.
KVM requires that the virtual machine host's processor has
virtualization support (named VT-x for Intel processors and AMD-V for AMD processors).

```bash
minikube start
kubectl get nodes
```

## Generate secret keys

The current secrets are not kept in Production. The Git Repository should not contain any passwords.

```bash
openssl base64
```

Ctrl + D

```bash
mix phx.gen.secret
```

## Database migration

1. Run `backend/priv/repo_migrations/{VERSION}_pre.sql`
2. Complete [API update](##update-api)
3. Run `backend/priv/repo_migrations/{VERSION}_post.sql`
   If `{VERSION}_post.sql` does not exist, skip this step.

## Update API

The `publish.sh` script is used to upload the Docker images to each Node.
You should create a `~/.ssh/config` to configure the connections.
I would also recommend using host aliases (`/etc/hosts`). Run without arguments
for an usage example:

```bash
sudo ./publish.sh
```
