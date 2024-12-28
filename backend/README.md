# Developing

Docker Compose is only used for developing. Phoenix can be run with Docker or with `mix phx.server`.
Phoenix will automatically recompile changed files.

```
sudo docker compose build
sudo docker compose up -d
```

## Database

### CLI

Password is found at `../docker-compose.yml`

```
psql -h localhost -p 5432 -U default -d dev
```

### Migrations

Inside `psql` execute:

```
dev=# \i ./priv/repo_migrations/v0.1.0.sql 
```

# Deploying
