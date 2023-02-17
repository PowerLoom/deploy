#Temporary steps until we can fix the caching issue in build context #FIXME

cd ../audit-protocol-private/ && ./build-docker.sh;
cd ../fpmm-pooler-internal/ && ./build-docker.sh;
cd ../pooler-frontend/ && ./build-docker.sh;
cd ../deploy;

docker-compose -f docker-compose-dev.yaml up -V --abort-on-container-exit
#docker-compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit