# PowerLoom Deployment
Scripts to deploy PowerLoom services (`audit-protocol` and `pooler`) to [offchain consensus](https://medium.com/powerloom/open-sesame-deb52685bacb).

> Note: In this private alpha, you need a UUID from us to participate in the `hosted` consensus. Please [fill this form](https://powerloom.io/consensus-invite) to request access.

## Requirements

1. Latest version of `docker` (`>= 20.10.21`) and `docker-compose` (`>= v2.13.0`)
2. At least 4 core CPU, 8GB RAM and 50GB SSD - make sure to chose the correct spec when deploying to Github Codespaces.
3. IPFS daemon (locally or remote instance with API port `5001` tunneled to localhost).
    - While we have __included__ this in our autobuild docker setup, we've noticed issues on non-server setups.
    - Regardless, IPFS daemon can hog __*a lot*__ of resources - it is not recommended to run this on a personal computer unless you have a strong internet connection and dedicated CPU+RAM.
    - _3rd party IPFS services such as Pinata/Infura are not supported_
4. RPC URL for `Ethereum mainnet`. We recommend running a full geth node to save costs and to stick to ethos of decentralization :)
> Our default (lite mode) setup is designed to work well with a free plan on any of the RPC providers like [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5), [Infura](https://infura.io), [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458), etc. It even works with Ankr's [public endpoint](https://rpc.ankr.com/eth) but we recommend signing up to track usage. For those interested in exploring the the full setup, we can also arrange for a special pan through our partners such as BlockVigil.

## For snapshotters

1. Copy `env.example to .env`
    - Ensure `RPC_URL` and `UUID` are filled.
    - Optionally, you may also set `WEB3_STORAGE_TOKEN` which can be generated/retreived from your [API tokens page](https://web3.storage/tokens/?create=true) after signing for a free plan at web3.storage.
    - `CONSENSUS_URL` should be left empty unless you have been instructed to do by our team.

2. Run the following command (ideally in a `screen`) and follow instructions

    `./build.sh`

3. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](http://localhost:3000) to see a UNISWAPV2 summary data dashboard similar to [PowerLoom UNISWAPV2 Prod](https://uniswapv2.powerloom.io/).
    - A sample screenshot of the dashboard is given [here](./sample_images/pooler-frontend.jpg)

    - This will also give an idea in case your snapshotting has fallen behind as you can notice from the time of last snapshot shown in the screenshot.

    - Note that the data shown in your own dashboard will not be same as production UI on PowerLoom.io as the "lite mode" is only set to snapshot 7 pair contracts. Refer to contributors section below to enable all pairs.

4. We have setup a bare-bones consensus dashboard at: [offchain-consensus.powerloom.io](https://offchain-consensus.powerloom.io/)

5. To shutdown services, just press `Ctrl+C` (and again to force).

    > If you don't keep services running for extended periods of time, this will affect consensus and we may be forced to de-activate your snapshotter UUID.
    
6. If you see issues with data, you can do a clean *reset* by running the following command before restarting step 3:

    `docker-compose down --volumes`

## Instructions for code contributors

1. Ensure `settings.json` and `static/cached_pair_addresses.json` files are populated in relevant directories
    - `../audit-protocol`
    - `../pooler`
    - `../offchain-consensus` (if used)
    - others such as `../pooler-frontend` and `../ap-consensus-dashboard` will work by default but do require the latest code to be cloned in the parent directory. Refer to script below.

2. Run the following command:

    `./build-dev.sh`

## Questions?
1. Ask on our [Discord](https://discord.com/channels/777248105636560948/1063022869040353300) - if you don't see the channel, ask an admin to add the snapshotter `role` to your account.
2. Create an [issue](https://github.com/PowerLoom/deploy/issues/new)
