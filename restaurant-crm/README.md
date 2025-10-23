## Restaurant CRM (Laravel 11 + Vue 3)

A production-ready full-stack CRM tailored for digital marketing agencies managing restaurant clients.

### Quick start (Docker)

```bash
cp .env.example .env
docker compose up -d --build
# first bootstraps Laravel, runs migrations & seeders
open http://localhost:8080
```

### Services
- PHP-FPM 8.3 (app, worker)
- Nginx (port 8080)
- MySQL 8 (port 3307)
- Redis 7 (port 6380)
- Laravel Echo Server (port 6001)

### Tech
- Laravel 11, Sanctum, Redis queue, Broadcasting
- Vue 3 + Vite, Axios, Laravel Echo
- Stripe & Razorpay billing (webhooks, refunds)
- Plivo telephony, Twilio/MessageBird WhatsApp
- ElevenLabs TTS/STT with Node microservice example
- Supervisor for workers

### Webhooks & Signatures
- Stripe: set endpoint to `/api/billing/stripe/webhook`; set `STRIPE_WEBHOOK_SECRET`
- Razorpay: `/api/billing/razorpay/webhook`; set `RAZORPAY_WEBHOOK_SECRET`
- Plivo: `PLIVO_ANSWER_URL` and `/api/plivo/recording` `/api/plivo/status` with signature validation
- Twilio WhatsApp: `/api/whatsapp/twilio/webhook`; set `TWILIO_WEBHOOK_SECRET`
- MessageBird: `/api/whatsapp/messagebird/webhook` with `MESSAGEBIRD_SIGNING_KEY`

### Deploy
- See `scripts/deploy.sh`, Supervisor in `docker/supervisor/supervisord.conf`
- Run `php artisan migrate --force` and ensure queues running
- Configure SSL at reverse proxy; set `APP_URL`

### Admin Setup
- Fill `.env` with provider keys
- Register webhooks in providers dashboards
- Verify signatures via provided middleware/utilities
- Troubleshooting: check `storage/logs/laravel.log`, supervisor logs, Redis connectivity
