# Frontend depends on the vendor assets
# For cleaner final build we do composer install twice
FROM public.ecr.aws/composer/composer:2 AS composer

COPY --link ../ /app/

WORKDIR /app

RUN composer install --ignore-platform-reqs --no-scripts --no-interaction

# Where we get the clean composer binary
FROM public.ecr.aws/composer/composer:2-bin AS composer-bin

# Where we build the frontend
FROM public.ecr.aws/docker/library/node:20-alpine3.19 AS node

COPY --from=composer --link /app /frontend/

WORKDIR /frontend

RUN yarn && yarn run build

# This is the final image, so we make it as small as possible
FROM public.ecr.aws/nginx/unit:php8.2 AS base
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt update && \
    apt install -y \
    unzip

# Getting standalone composer binary
COPY --from=composer-bin --link /composer /usr/bin/composer

# Copy over the Nginx Unit configuration
COPY --link ../.devops/configs/unit/ /docker-entrypoint.d/

COPY --from=node --link /frontend /app

WORKDIR /app

RUN composer install --no-interaction

