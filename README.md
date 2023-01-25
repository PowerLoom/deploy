# PowerLoom Deployment
Scripts to deploy PowerLoom services (`audit-protocol` and `pooler`) to off chain consensus.

_Note: Access by invitation only for now - please reach out to snapshotters@powerloom.io_

## Requirements

1. Latest version of `docker` and `docker-compose`
2. At least 4 core CPU, 8GB RAM and 50GB SSD.
2. IPFS daemon (locally or remote instance with API port `5001` tunneled to localhost).
    - While we have __included__ this in our autobuild docker setup, we've noticed issues on non-server setups.
    - Regardless, IPFS can hog __*a lot*__ of resources - it is not recommended to run this on a personal computer.
> 3rd party IPFS services such as Pinata/Infura are not supported
3. RPC URL for Ethereum mainnet. We recommend running a full geth node to save costs but for this phase, any of the following should suffice.
    - [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5) (preferred) __$49/mo__
    - [Infura](https://infura.io) _~$100/mo_ but requires __$225/mo__ plan
    - [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458) __$299/mo__
    - BlockVigil (reach out to us to request a _free_ plan)

## For snapshotters

1. Copy `env.example to .env` and ensure `RPC_URL` and `UUID` is filled. Optionally, you may also set `WEB3_STORAGE_TOKEN` which can be generated/retreived from your [API tokens page](https://web3.storage/tokens/?create=true) after signing for a free plan at web3.storage.

2. Setup docker to login with your Github:

    - Get your Github personal access token [(classic)](https://github.com/settings/tokens/new). We recommend only giving the `read:packages` permission so this token cannot be abused.

    - Set it in your environment: `export CR_PAT='<personal access token here>'`

    - Login to docker using it: ` echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin`

3. Run the following command (ideally in a `screen`) and follow instructions

    `./build.sh`

4. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](http://localhost:3000) to see a UNISWAPV2 summary data dashboard similar to [PowerLoom UNISWAPV2 Prod](https://uniswapv2.powerloom.io/).
    - A sample screenshot of the dashboard is given [here](./sample_images/pooler-frontend.jpg)

    - This will also give an idea in case your snapshotting has fallen behind as you can notice from the time of last snapshot shown in the screenshot.

    - Note that the data shown in your own dashboard will not be same as PowerLoom UNISWAPV2 prod as the number of pair cotracts that are being snapshotted is limited to 20 for the current release.

5. We have setup a bare-bones consensus dashboard at: [offchain-consensus.powerloom.io](https://offchain-consensus.powerloom.io/)

6. To shutdown services, just press `Ctrl+C` (and again to force).

    > If you don't keep services running for extended periods of time, this will affect consensus and we may be forced to de-activate your snapshotter UUID.
    
7. If you see issues with data, you can do a clean *reset* by running the following command before restarting step 3:

    `docker-compose down --volumes`

## Instructions for code contributors

1. Ensure settings and static files are populated on both directories (`../audit-protocol-private` and `../fpmm-pooler-internal`) and `../pooler-frontend` exists.

2. Run the following command:

    `./build-dev.sh`

## Questions?
1. Ask on our [Discord](https://discord.com/channels/777248105636560948/1063022869040353300)
2. Create an [issue](https://github.com/PowerLoom/deploy/issues/new)
