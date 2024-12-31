FROM node:23-alpine AS build

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .

RUN npm run build

FROM nginx:1.27-alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx
COPY nginx_server.conf /etc/nginx/templates/nginx_server.conf.template

CMD ["nginx", "-g", "daemon off;"]
