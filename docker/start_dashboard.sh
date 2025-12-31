#!/bin/sh
set -e

echo "🚀 Starting Dashboard Server (Docker optimized)..."

# Skip dependency checks as they are handled in the Dockerfile
# Launch the dashboard directly using the built files
exec node --enable-source-maps ./dist/index.js -dashboard
