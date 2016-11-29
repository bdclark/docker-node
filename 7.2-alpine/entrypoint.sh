#!/bin/sh
set -e

if [ "$1" = "node" ] || [ "$1" = "npm" ]; then
  chown -R node:node /app
  exec su-exec node "$@"
fi

exec "$@"
