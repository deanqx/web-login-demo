FROM node:23-alpine AS build

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .

RUN npm run build

# TODO redirect of /api
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
