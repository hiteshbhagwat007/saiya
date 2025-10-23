#!/usr/bin/env bash
set -euo pipefail

# Example deployment script for a Linux host with Docker
# Usage: ./scripts/deploy.sh myregistry/restaurant-crm:latest

IMAGE_TAG="${1:-restaurant-crm:latest}"

echo "Building production images..."
docker build -t "$IMAGE_TAG-php" ./docker/php
docker build -t "$IMAGE_TAG-nginx" ./docker/nginx

echo "Pushing images (if registry configured)..."
# docker push "$IMAGE_TAG-php"
# docker push "$IMAGE_TAG-nginx"

echo "Running database migrations..."
docker compose run --rm app php artisan migrate --force

echo "Restarting services..."
docker compose up -d --no-deps app worker nginx

echo "Clearing caches..."
docker compose exec app php artisan optimize:clear

echo "Deployment complete."
