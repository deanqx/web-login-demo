# Developing

Docker Compose is only used for developing.
Phoenix will automatically recompile changed files.

## Launch Phoenix API server

### Native

```bash
mix phx.server
```

### with Docker

```bash
docker compose build
docker compose up -d
```

## Database

### CLI

Password is found at `../docker-compose.yml`

```bash
psql -h localhost -p 5432 -U default -d dev
```

### Migrations

Inside `psql` execute:

```
dev=# \i ./priv/repo_migrations/v0.1.0.sql 
```

# Deploying
