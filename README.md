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
- Bootstrap (future)

The website contains

- a login
- an admin interface to create new users and edit old ones
- an editable user profile with profile picture upload

## Backend

- Nginx
- Pheonix (Elixir)
- Postgres
- NixOS
- Docker
- Private Docker Registry
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
docker compose up -d web
```

## Generate secret keys

The current secrets are not kept in Production. The Git Repository should not contain any passwords.

```bash
openssl base64
```

Use `Ctrl + D` to exit.

```bash
mix phx.gen.secret
```

```bash
mkdir .certs
cd .certs
```

### Certificate Authority (Public)
### Registry Certificate (Private)

mTLS

`ca_cert.pem`: Public

```bash
./create_certs.sh
```

### Node Certificate (Private)

The following generates a certificate for a node. This information is private for each node.

```bash
./create_node_cert.sh certs dean
```

```bash
mkdir /etc/docker/certs.d
mkdir /etc/docker/certs.d/registry.internal:5000
cp dean/* /etc/docker/certs.d/registry.internal:5000
systemctl restart docker
docker login registry.internal:5000
```

## Testing with Minikube

For Linux users it is recommended to use KVM (Kernel-based Virtual Machine) over Virtualbox.
KVM requires that the virtual machine host's processor has
virtualization support (named VT-x for Intel processors and AMD-V for AMD processors).

```bash
minikube start
minikube ip
```

```bash
minikube addons enable registry
minikube start --insecure-registry "<registry-ip>:5000"
```

```bash
docker volume create registry_data
```

```bash
docker run -d \
  -p 5000:5000 \
  -v ./.certs:/certs \
  -v registry_data:/var/lib/registry \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry_cert.pem \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry_key.pem \
  --name registry \
  --restart unless-stopped \
  registry:2
```

```bash
ip addr show
```

`/etc/hosts`

```
192.x.x.x registry.internal
```


Build Docker Images and push to Minikube:

```bash
./publish.sh [Version] minikube
```

```bash
kubectl apply -f kubernetes/api.yaml
kubectl apply -f kubernetes/web.yaml
kubectl get deploy
kubectl get pods
```

```bash
kubectl describe pod api-deployment-xxx
```

Every Pod needs the status: `a`

```bash
minikube delete
```

## Database migration

1. Run `backend/priv/repo_migrations/{VERSION}_pre.sql`
2. Complete [API update](##update-api)
3. Run `backend/priv/repo_migrations/{VERSION}_post.sql`
   If `{VERSION}_post.sql` does not exist, skip this step.

## Push update to nodes

The `publish.sh` script is used to upload the Docker images to each Node.
You should create a `~/.ssh/config` to configure the connections.
I would also recommend using host aliases (`/etc/hosts`). Run without arguments
for an usage example:

```bash
./publish.sh
```

```bash
ssh [Master Node]
```

Update version number in `api.yaml` and `web.yaml` on the Master Node.

```bash
kubectl apply -f api.yaml
kubectl apply -f web.yaml
```
