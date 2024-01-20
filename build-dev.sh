#Make sure the repos mentioned in comments are cloned in the parent directory of this repo

#cd ../ && git clone https://github.com/PowerLoom/audit-protocol.git;
cd ../audit-protocol/ && ./build-docker.sh;

#cd ../ && git clone https://github.com/Seth-Schmidt/pooler.git;
cd ../pooler/ && ./build-docker.sh;

#cd ../ && git clone https://github.com/Seth-Schmidt/pooler-frontend.git;
cd ../pooler-frontend/ && ./build-docker.sh;

# Not currently supported for this branch
#cd ../ && git clone https://github.com/PowerLoom/ap-consensus-dashboard.git;
# cd ../ap-consensus-dashboard/ && ./build-docker.sh;

cd ../deploy;

# Use this for local IPFS node
docker-compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
# Use this if you're using external IPFS node
#docker-compose -f docker-compose-dev.yaml up -V --abort-on-container-exit

#Reset command:
#docker-compose -f docker-compose-dev.yaml --profile ipfs down --volumes
