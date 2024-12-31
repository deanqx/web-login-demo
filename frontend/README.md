# Developing

## Git

Test Docker Compose before merging in `main`.

```bash
docker compose build
docker compose down
docker compose up
```

## Starting Backend

```bash
docker compose build api
docker compose up -d api
```

## Starting Web server

Reloads changed files automatically.

```
npm run dev
```
