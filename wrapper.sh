#!/bin/bash
#
# Start NGINX
echo "Trying to start NGINX..."
nginx
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start NGINX: $status"
  exit $status
else
  echo "...started."
fi

# Change to installation directory
cd /openprocurement.buildout

# Start circus
echo "Trying to start circusd..."
bin/circusd --daemon
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start circusd: $status"
  exit $status
else
  echo "...started."
fi

# Start API
echo "Trying to start the API (chausette)..."
bin/chaussette paste:etc/openprocurement.api.ini
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start API (chausette): $status"
  exit $status
else
  echo "...started."
fi


# Naive check runs checks once a minute to see if either of the processes exited.
# The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep nginx |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep circusd |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep chausette |grep -q -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
