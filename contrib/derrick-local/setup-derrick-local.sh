#!/bin/bash

LOGDIR="${DERRICK_LOG_DIR:-"/tmp"}"
DBDIR="${DERRICK_DB_DIR:-"."}"

echo
echo "==> Starting derrick server"
echo
echo "database dir: ${DBDIR}"

derrick server run -accept-tos -advertise-addr=127.0.0.1:9701 \
  -listen-grpc=0.0.0.0:9701 -listen-http=0.0.0.0:9702 -db=$DBDIR/data.db \
  -advertise-tls-skip-verify -url-enabled -vvv > $LOGDIR/wp-server-logs.txt 2>&1 &

echo
echo "==> Bootstrapping derrick server"
echo
echo "Server bootstrap token will print to STDOUT"

derrick server bootstrap -server-addr=127.0.0.1:9701 -server-tls-skip-verify

echo
echo "=>> Starting a derrick runner"
echo

derrick runner agent -vvv > $LOGDIR/wp-runner-logs.txt 2>&1 &

echo
echo "Finished setting up a local derrick server and runner!"
echo 
echo "Database file saved at: ${DBDIR}/data.db"
echo
echo "Logs can be found at:"
echo "derrick server: ${DERRICK_LOG_DIR}/wp-server-logs.txt"
echo "derrick runner: ${DERRICK_LOG_DIR}/wp-runner-logs.txt"
