#!/bin/bash

echo "Puppeteer tests runner..."

if [ -f /pre.sh ]; then
    /pre.sh
fi

if [ "$WAIT_CONNECT_HOST" != "" ]; then
    if [ "$WAIT_CONNECT_PORT" == "" ]; then
        echo "WAIT_CONNECT_PORT must be defined"
        exit 1
    fi
    echo "Waiting for a successful tcp connection to $WAIT_CONNECT_HOST:$WAIT_CONNECT_PORT before proceding..."
    while ! nc -z $WAIT_CONNECT_HOST $WAIT_CONNECT_PORT; do   
        sleep 0.3
    done        
fi

if [ "$WAIT_TIME_SECONDS" != "" ]; then
    echo "Waiting $WAIT_TIME_SECONDS seconds before launching tests..."
    sleep $WAIT_TIME_SECONDS
fi

echo "Launching tests..."
cd /app
export RIB=""
if [ "$JEST_RUN_IN_BAND"=="true" ]; then
    export RIB="--runInBand"
fi
jest --bail $JEST_MAX_FAILURES $RIB --testTimeout=$JEST_TEST_TIMEOUT --maxConcurrency=$JEST_MAX_CONCURRENCY
RE=$?

exit $RE
