#!/bin/sh
set -e

echo "🚀 Starting combined services (Cron + Dashboard)..."

# Start Cron service in background
# In Debian containers, 'service cron start' or direct execution works.
# Since we want it in background so we can run dashboard in foreground:
service cron start

# Start Dashboard in foreground
exec node --enable-source-maps ./dist/index.js -dashboard
