# Developing

Docker Compose is only used for developing.
Phoenix will automatically recompile changed files.

## Starting Phoenix API server

```bash
docker compose up -d db
mix phx.server
```

## Test with Docker Container

```bash
docker compose build api
docker compose up -d api
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

https://hexdocs.pm/phoenix/releases.html
