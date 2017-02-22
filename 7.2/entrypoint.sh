#!/bin/bash
set -e

if [ "$1" = "node" ] || [ "$1" = "npm" ]; then
  chown -R node:node /app
  exec gosu node "$@"
fi

exec "$@"
