#!/bin/bash
source .env
echo "cleaning up...";
rm -rf audit-protocol;
rm -rf pooler;
rm -rf pooler-frontend;
rm -rf logs/pooler/*;
rm -rf logs/audit-protocol/*;
rm -rf logs/pooler-frontend/*;

# set to clone fork, will update when repos are merged
echo "setting up codebase...";
git clone https://github.com/Seth-Schmidt/audit-protocol.git audit-protocol;
cd audit-protocol/;
git checkout aave;
cd ../;

git clone https://github.com/Seth-Schmidt/pooler.git pooler;
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
    cd ../../../;
fi

cd ../;

git clone https://github.com/Seth-Schmidt/pooler-frontend.git pooler-frontend;
cd pooler-frontend;
git checkout aave;
cp -n env.example .env

echo "bootstrapping complete!";
