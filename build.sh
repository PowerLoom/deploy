#!/bin/bash

source .env

echo "testing before build...";

if [ -z "$RPC_URL" ]; then
    echo "RPC URL not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$UUID" ]; then
    echo "UUID not found, please set this in your .env!";
    exit 1;
fi

echo "Found RPC URL ${RPC_URL}";

echo "Found UUID ${UUID}";

echo "WEB3_STORAGE_TOKEN ${WEB3_STORAGE_TOKEN}";

if [ "$CONSENSUS_URL" ]; then
    echo "Found CONSENSUS_URL ${CONSENSUS_URL}";
fi

echo "building...";

if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'docker compose not found, trying to see if compose exists within docker';
    docker compose pull;
    docker compose up -V --abort-on-container-exit
else
    docker-compose pull;
    docker-compose up -V --abort-on-container-exit
fi