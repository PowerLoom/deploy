#!/bin/bash
source .env
echo "cleaning up...";
rm -rf audit-protocol;
rm -rf pooler;
rm -rf pooler-frontend;
rm -rf ap-consensus-dashboard;
rm -rf logs/pooler/*;
rm -rf logs/audit-protocol/*;
rm -rf logs/pooler-frontend/*;
rm -rf logs/ap-consensus-dashboard/*;

echo "setting up codebase...";
cd ../ && git clone https://github.com/PowerLoom/audit-protocol.git;

# set to clone fork, will update when repos are merged
git clone https://github.com/Seth-Schmidt/pooler.git;

cd pooler/;
git checkout aave;
if [ "$SNAPSHOT_CONFIG_REPO" ]; then
    echo "Found SNAPSHOT_CONFIG_REPO ${SNAPSHOT_CONFIG_REPO}";
    rm -rf config;
    git clone $SNAPSHOT_CONFIG_REPO config;
    cd config;
    if [ "$SNAPSHOT_CONFIG_REPO_BRANCH" ]; then
        echo "Found SNAPSHOT_CONFIG_REPO_BRANCH ${SNAPSHOT_CONFIG_REPO_BRANCH}";
        git checkout $SNAPSHOT_CONFIG_REPO_BRANCH;
    fi
    cd ../;
fi

if [ "$SNAPSHOTTER_COMPUTE_REPO" ]; then
    echo "Found SNAPSHOTTER_COMPUTE_REPO ${SNAPSHOTTER_COMPUTE_REPO}";
    rm -rf snapshotter/modules/computes;
    cd snapshotter/modules/;
    git clone $SNAPSHOTTER_COMPUTE_REPO computes;
    cd computes;
    if [ "$SNAPSHOTTER_COMPUTE_REPO_BRANCH" ]; then
        echo "Found SNAPSHOTTER_COMPUTE_REPO_BRANCH ${SNAPSHOTTER_COMPUTE_REPO_BRANCH}";
        git checkout $SNAPSHOTTER_COMPUTE_REPO_BRANCH;
        cp -n settings/settings_example.json settings/settings.json
    fi
    cd ../../../../;
fi

git clone https://github.com/Seth-Schmidt/pooler-frontend.git;
cd pooler-frontend/;
git checkout aave;

cd ../ && git clone https://github.com/Seth-Schmidt/ap-consensus-dashboard.git;
cd ap-consensus-dashboard/;
git checkout aave;
cd ../deploy;


echo "bootstrapping complete!";