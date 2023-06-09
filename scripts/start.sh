#!/bin/sh

set -e

# used fpr running inside the Docker container
echo "run db migration"
source /app/app.env
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@" # execute all passed input parameters to script