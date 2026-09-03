FROM node:22-alpine AS builder

ARG NPM_REGISTRY=https://registry.npmjs.org

WORKDIR /build

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --registry="${NPM_REGISTRY}"

COPY frontend/ ./
RUN npm run build:prod

FROM nginx:1.28-alpine

COPY backend/docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /build/dist/ /usr/share/nginx/html/

EXPOSE 80

