#!/usr/bin/env bash
set -euo pipefail

cd /var/www/html

# Bootstrap Laravel skeleton if artisan is missing
if [ ! -f artisan ]; then
  echo "[bootstrap] Creating Laravel skeleton in /tmp/laravel..."
  rm -rf /tmp/laravel
  composer create-project laravel/laravel:^11 /tmp/laravel

  echo "[bootstrap] Syncing skeleton into project (preserve custom files)..."
  rsync -a /tmp/laravel/ ./ --ignore-existing

  echo "[bootstrap] Requiring PHP packages..."
  composer require predis/predis guzzlehttp/guzzle:^7 stripe/stripe-php razorpay/razorpay twilio/sdk messagebird/php-rest-api plivo/plivo-php sentry/sentry-laravel:^4 laravel/sanctum

  # Overlay step is optional if repository already contains app code
  if [ -d overlay ]; then
    echo "[bootstrap] Applying overlay files..."
    rsync -a overlay/ ./
  fi

  echo "[bootstrap] Node dependencies..."
  if [ -f package.json ]; then
    npm pkg set type="module" >/dev/null 2>&1 || true
    npm install
    npm run build || true
  fi

  echo "[bootstrap] Copy .env and generate key..."
  if [ ! -f .env ] && [ -f .env.example ]; then
    cp .env.example .env
  fi
  php artisan key:generate --force

  echo "[bootstrap] Run migrations and seeders..."
  php artisan migrate --force
  php artisan db:seed --force
fi

exec "$@"
