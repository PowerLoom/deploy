#!/bin/bash
source .env

echo "testing before build...";

if [ -z "$SOURCE_RPC_URL" ]; then
    echo "RPC URL not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$SIGNER_ACCOUNT_ADDRESS" ]; then
    echo "SIGNER_ACCOUNT_ADDRESS not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$SIGNER_ACCOUNT_PRIVATE_KEY" ]; then
    echo "SIGNER_ACCOUNT_ADDRESS not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$SEQUENCER_ID" ]; then
    echo "SEQUENCER_ID not found, please set this in your .env!";
    exit 1;
fi

echo "Found SOURCE RPC URL ${SOURCE_RPC_URL}";

echo "Found SIGNER ACCOUNT ADDRESS ${SIGNER_ACCOUNT_ADDRESS}";

if [ "$PROST_RPC_URL" ]; then
    echo "Found PROST_RPC_URL ${PROST_RPC_URL}";
fi

if [ "$PROST_CHAIN_ID" ]; then
    echo "Found PROST_CHAIN_ID ${PROST_CHAIN_ID}";
fi

if [ "$IPFS_URL" ]; then
    echo "Found IPFS_URL ${IPFS_URL}";
fi

if [ "$PROTOCOL_STATE_CONTRACT" ]; then
    echo "Found PROTOCOL_STATE_CONTRACT ${PROTOCOL_STATE_CONTRACT}";
fi

if [ "$RELAYER_HOST" ]; then
    echo "Found RELAYER_HOST ${RELAYER_HOST}";
fi

if [ "$WEB3_STORAGE_TOKEN" ]; then
    echo "Found WEB3_STORAGE_TOKEN ${WEB3_STORAGE_TOKEN}";
fi

if [ "$SLACK_REPORTING_URL" ]; then
    echo "Found SLACK_REPORTING_URL ${SLACK_REPORTING_URL}";
fi

if [ "$POWERLOOM_REPORTING_URL" ]; then
    echo "Found SLACK_REPORTING_URL ${POWERLOOM_REPORTING_URL}";
fi

cd audit-protocol/ && ./build-docker.sh;

cd ../pooler/ && ./build-docker.sh;

cd ../snapshotter-lite-local-collector/ && chmod +x build-docker.sh && ./build-docker.sh;
cd ../;


echo "building...";

if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'docker compose not found, trying to see if compose exists within docker';
    if [ -z "$IPFS_URL" ]; then
        docker compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
    else
        docker compose -f docker-compose-dev.yaml up --no-deps -V --abort-on-container-exit
    fi
else
    if [ -z "$IPFS_URL" ]; then
        docker-compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
    else
        docker-compose -f docker-compose-dev.yaml up --no-deps -V --abort-on-container-exit
    fi
fi