#!/bin/bash

echo "==> Attempting to gracefully shutdown Derrick server and runner..."
echo
echo "==> Shutting down derrick server"
echo

pkill --signal SIGINT -f "derrick server run"

echo
echo "==> Shutting down derrick runner"
echo

pkill --signal SIGINT -f "derrick runner agent"

echo
echo "Finished shutting down local derrick server and runner!"
echo
