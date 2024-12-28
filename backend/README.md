# Developing

Docker Compose is only used for developing.
Phoenix will automatically recompile changed files.

## Launching Phoenix API server

### Native

```bash
docker compose up -d db
mix phx.server
```

### with Docker

NOT WORKING FOR NOW

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
