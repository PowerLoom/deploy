# PowerLoom Deployment
Scripts to deploy PowerLoom services ([audit-protocol](https://github.com/PowerLoom/audit-protocol) and [pooler](https://github.com/PowerLoom/pooler)) to [PowerLoom Network](https://onchain-consensus.powerloom.io).

> Note: We just announced an incentivized testnet, [register here](https://coinlist.co/powerloom-testnet) to participate in the network.

## Requirements

1. Latest version of `docker` (`>= 20.10.21`) and `docker-compose` (`>= v2.13.0`)
2. At least 4 core CPU, 8GB RAM and 50GB SSD - make sure to choose the correct spec when deploying to Github Codespaces.
3. IPFS node
    - While we have __included__ a node in our autobuild docker setup, IPFS daemon can hog __*a lot*__ of resources - it is not recommended to run this on a personal computer unless you have a strong internet connection and dedicated CPU+RAM.
    - 3rd party IPFS services that provide default IFPS interface like Infura are now supported.
4. RPC URL for `Ethereum mainnet`. We recommend running a full geth node to save costs and to stick to ethos of decentralization! :)
> The default setup for this branch is designed to work well with a free plan on any of the RPC providers like [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5), [Infura](https://infura.io), [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458), etc. It even works with Ankr's [public endpoint](https://rpc.ankr.com/eth) but we recommend signing up to track usage. For those interested in exploring the the full setup, we can also arrange for a special pan through our partners such as BlockVigil.

## Running the Snapshotter Node

Clone the repository against the testnet branch.

 `git clone https://github.com/PowerLoom/deploy.git --single-branch powerloom_deploy --branch aave && cd powerloom_deploy`

 ### For snapshotters

1. Copy `env.example` to `.env`.
   - Ensure the following required variables are filled:
     - `SOURCE_RPC_URL`: The URL for Ethereum RPC (Local node/Infura/Alchemy) service.
     - `SIGNER_ACCOUNT_ADDRESS`: The address of the signer account. This is your whitelisted address on the protocol. **Using a burner account is highly recommended**
     - `SIGNER_ACCOUNT_PRIVATE_KEY`: The private key corresponding to the signer account address.
     - `PROST_RPC_URL`: The URL for the PROST RPC service.
     - `PROTOCOL_STATE_CONTRACT`: The contract address for the protocol state.
     - `RELAYER_HOST`: The host address for the relayer.
     - `NAMESPACE`: The unique key used to identify your project namespace
     - `PROST_CHAIN_ID`: The chain ID for the PROST RPC service.
   - Optionally, you may also set the following variables:
     around which all consensus activity takes place.
     - `POWERLOOM_REPORTING_URL`: The URL for reporting to PowerLoom.
     - `IPFS_URL`: The URL for the IPFS (InterPlanetary File System) service in HTTP(s) (e.g. `https://ipfs.infura.io:5001`) multiaddr format (e.g. `/dns/ipfs.infura.io/tcp/5001/https`)
     - `IPFS_API_KEY`: The API key for the IPFS service (if required).
     - `IPFS_API_SECRET`: The API secret for the IPFS service (if required).
     - `SLACK_REPORTING_URL`: The URL for reporting to Slack.
     - `WEB3_STORAGE_TOKEN`: The token for Web3.Storage. You can generate or retrieve this token from your [API tokens page](https://web3.storage/tokens/?create=true) after signing up for a free plan at web3.storage.

2. Run the following command (ideally in a `screen`) and follow instructions

    `./build.sh`

3. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](https://github.com/PowerLoom/pooler-frontend/tree/aave) to see an Aave V3 summary data dashboard similar to [PowerLoom Aave V3 Prod](https://aave-prod1.powerloom.io/).
    - A sample screenshot of the dashboard is given [here](./sample_images/aave-frontend.jpg)

    - The front-end does not come packaged as part of this deploy repository and will need to be run separately. Frontend deployment instructions can be found [here](https://github.com/PowerLoom/pooler-frontend/tree/aave?tab=readme-ov-file#powerloom-pooler-product).

    - The time of the last snapshot taken shown in the `Synced by` section on the dashboard can give an idea if your snapshotting has fallen behind.

## Instructions for code contributors

1. Copy `env-dev.example` to `.env`.
   - Ensure the following required variables are filled:
     - `SOURCE_RPC_URL`: The URL for the source RPC (Remote Procedure Call) service.
     - `SIGNER_ACCOUNT_ADDRESS`: The address of the signer account.
     - `SIGNER_ACCOUNT_PRIVATE_KEY`: The private key corresponding to the signer account address.
     - `SNAPSHOT_CONFIG_REPO`: The Github url of the `snapshotter-configs` repo to be used. Set to the Powerloom repository by default.
     - `SNAPSHOT_CONFIG_REPO_BRANCH`: The branch name to be used from the above configs repository. Set to `aave` by default.
     - `SNAPSHOTTER_COMPUTE_REPO`: The Github url of the `snapshotter-computes` repository to be used. Set to the Powerloom repository by default.
     - `SNAPSHOTTER_COMPUTE_REPO_BRANCH`: The branch name to be used from the above compute repository. Set to `aave` by default.
     - `PROST_RPC_URL`: The URL for the PROST RPC service.
   - Optionally, you may also set the following variables:
     - `IPFS_URL`: The URL for the IPFS (InterPlanetary File System) service in HTTP(s) (e.g. `https://ipfs.infura.io:5001`) multiaddr format (e.g. `/dns4/ipfs.infura.io/tcp/5001/https`)
     - `IPFS_API_KEY`: The API key for the IPFS service (if required).
     - `IPFS_API_SECRET`: The API secret for the IPFS service (if required).
     - `RELAYER_HOST`: The host address for the relayer.
     - `SLACK_REPORTING_URL`: The URL for reporting to Slack.
     - `POWERLOOM_REPORTING_URL`: The URL for reporting to PowerLoom.
     - `WEB3_STORAGE_TOKEN`: The token for Web3.Storage. You can generate or retrieve this token from your [API tokens page](https://web3.storage/tokens/?create=true) after signing up for a free plan at web3.storage.

2. Run `./bootstrap.sh` to populate the necessary directories.

3. Check that the correct branch provided in the `.env` during Step 1 is checked out in the necessary directories (Should be handled by `./bootstrap.sh`):
    - `pooler/config`
    - `pooler/snapshotter/modules/computes`
        - Refer to [Pooler Architecture](https://github.com/PowerLoom/pooler?tab=readme-ov-file#architecture) for help with Git Submodules.
        - Refer to [Aave snapshotter-computes](https://github.com/Powerloom/snapshotter-computes/tree/aave?tab=readme-ov-file#overview) to see setup instructions for the compute module.

4. Run the following command (ideally in a `screen`)

    `./build-dev.sh`

5. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](https://github.com/PowerLoom/pooler-frontend/tree/aave) to see an Aave V3 summary data dashboard similar to [PowerLoom Aave V3 Prod](https://aave-prod1.powerloom.io/).
    - A sample screenshot of the dashboard is given [here](./sample_images/aave-frontend.JPG)

    - The front-end does not come packaged as part of this deploy repository and will need to be run separately. Frontend deployment instructions can be found [here](https://github.com/PowerLoom/pooler-frontend/tree/aave?tab=readme-ov-file#powerloom-pooler-product).

    - The time of the last snapshot taken shown in the `Synced by` section on the dashboard can give an idea if your snapshotting has fallen behind.

    - The configuration is set to snapshot all Aave V3 assets by default. Refer to [Aave snapshotter-computes](https://github.com/Powerloom/snapshotter-computes/tree/aave?tab=readme-ov-file#configuration) to change which assets are tracked.

## Troubleshooting

1. If you see the following error, your snapshotter address is not registered.

    ```
    powerloom_deploy-pooler-1           | Snapshotter identity check failed on protocol smart contract
    powerloom_deploy-pooler-1 exited with code 1
    ```
    You can reach out to us on [Discord](https://powerloom.io/discord) to get your address whitelisted.

2. Check if all the necessary docker containers are up and running. You should see an output against `docker ps` with the following cotnainers listed:

```
    # docker ps

    CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS                        PORTS                                                                                                         NAMES

    cbeed6b78b1c   powerloom-pooler           "bash -c 'sh snapsho…"   About a minute ago   Up 49 seconds (healthy)       0.0.0.0:8002->8002/tcp, 0.0.0.0:8555->8555/tcp                                                                powerloom_deploy-pooler-1

    39773c029247   powerloom-audit-protocol   "bash -c 'sh snapsho…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:9000->9000/tcp, 0.0.0.0:9002->9002/tcp, 0.0.0.0:9030->9030/tcp                                        powerloom_deploy-audit-protocol-1

    a8e7413cf980   rabbitmq:3-management      "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp   powerloom_deploy-rabbitmq-1

    48c241b1c926   ipfs/kubo:release          "/bin/sh -c ' echo '…"   About a minute ago   Up About a minute (healthy)   4001/tcp, 8080-8081/tcp, 4001/udp, 0.0.0.0:5001->5001/tcp                                                     powerloom_deploy-ipfs-1

    64e2213cdcb3   redis:alpine               "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:6379->6379/tcp                                                                                        powerloom_deploy-redis-1
```

3. To be sure whether your snapshotter is processing epochs and submitting snapshots for consensus, run the following internal API query on Pooler Core API from your browser.

> For detailed documentation on internal APIs and the low level details exposed by them, refer to the [Pooler docs](https://github.com/PowerLoom/pooler?tab=readme-ov-file#internal-snapshotter-apis).

**Tunnel from your local machine to the remote deploy instance on the [`core_api`](https://github.com/PowerLoom/pooler/tree/nms_master?tab=readme-ov-file#core-api) port**

This opens up port 8002.

```
ssh -nNTv -L 8002:localhost:8002 root@<remote-instance-IP-address>
```

Replace `<remote-instance-IP-address>` with the IPv4 address of the remote deploy instance.

The following query will return the processing status of the last epoch as it passes through the different state transitions.

**Check epoch processing status**

Visit `http://localhost:8002/internal/snapshotter/epochProcessingStatus?page=1&size=1` on your browser to know the status of the latest epoch processed by Pooler.

![Pooler Epoch Processing Status Internal API](sample_images/pooler_internal_epoch_status.png)

Most of the project IDs as captured at every state transition should show a status of `success`.

**Check the current epoch on the protocol**

Visit `http://localhost:8002/current_epoch` on your browser to know the current epoch being processed by the protocol. If the `epochId` field from the previous query and this one are too far apart, the deploy setup is most likely 

* running into RPC issues, or 
* system resource limit issues which causes the host to kill off processes

![Pooler API current epoch](sample_images/pooler_current_epoch.png)

### Stopping and Resetting
1. To shutdown services, just press `Ctrl+C` (and again to force).

    > If you don't keep services running for extended periods of time, this will affect consensus and we may be forced to de-activate your snapshotter account.
    
2. If you see issues with data, you can do a clean *reset* by running the following command:

- For Snapshotters: `docker-compose --profile ipfs down --volumes`
- For Code Contributors: 
    `docker-compose -f docker-compose-dev.yaml --profile ipfs down --volumes`

## Questions?
1. Ask on our [Discord](https://powerloom.io/discord) - if you don't see the channel, ask an admin to add the snapshotter `role` to your account.
2. Create an [issue](https://github.com/PowerLoom/deploy/issues/new)
