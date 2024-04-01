#!/bin/bash
source .env
echo "cleaning up...";
rm -rf audit-protocol;
# rm -rf pooler;
# rm -rf logs/pooler/*;
rm -rf logs/audit-protocol/*;

echo "setting up codebase...";

git clone https://github.com/PowerLoom/submission-sequencer.git;
cd submission-sequencer;
git checkout relayer_broadcast;
cd ..;

git clone https://github.com/PowerLoom/validator-alpha.git;
cd validator-alpha;
git checkout redis_improvements;
cd ..;

git clone https://github.com/PowerLoom/audit-protocol.git;

git clone https://github.com/PowerLoom/pooler.git;
cd pooler/;
git checkout feat/proto_submissions;
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
    fi
    cd ../../../;
fi

cd ../;

echo "bootstrapping complete!";