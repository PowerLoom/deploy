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

#Make sure the repos mentioned in comments are cloned in the parent directory of this repo

#cd ../ && git clone https://github.com/PowerLoom/audit-protocol.git;
cd ../audit-protocol/ && ./build-docker.sh;

#cd ../ && git clone https://github.com/Seth-Schmidt/pooler.git;
cd ../pooler/ && ./build-docker.sh;

# cd ../ && git clone https://github.com/Seth-Schmidt/pooler-frontend.git;
cd ../pooler-frontend/ && ./build-docker.sh;

#cd ../ && git clone https://github.com/Seth-Schmidt/ap-consensus-dashboard.git;
cd ../ap-consensus-dashboard/ && ./build-docker.sh;

cd ../deploy;

# Use this for local IPFS node
docker-compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
# Use this if you're using external IPFS node
#docker-compose -f docker-compose-dev.yaml up -V --abort-on-container-exit

#Reset command:
#docker-compose -f docker-compose-dev.yaml --profile ipfs down --volumes
