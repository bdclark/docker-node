#!/usr/bin/dumb-init /bin/sh
set -e

# allow the container to be started with `--user`
# all node/npm commands should be dropped to the correct user
if [ "$1" = "node" ] || [ "$1" = "npm" ] && [ "$(id -u)" = '0' ]; then
  chown -R node:node /app
  exec su-exec node "$0" "$@"
fi

exec "$@"
