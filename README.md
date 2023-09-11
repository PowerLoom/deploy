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
> While the current testnet setup defaults to a "lite mode" and works with free RPCs, it's highly recommended to signup with one of these providers to at least track usage even if you aren't on a paid plan: [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5), [Infura](https://infura.io), [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458), etc. Please reach out to us if none of the options are viable.

## For snapshotters

1. Clone the repository for pretask simulation.

 `git clone https://github.com/PowerLoom/deploy.git --single-branch powerloom_testnet_5_pairs --branch testnet_5_pairs && cd powerloom_testnet_5_pairs`

2. Copy `env.example` to `.env`.
   - Ensure the following required variables are filled:
     - `SOURCE_RPC_URL`: The URL for the source RPC (Local node/Infura/Alchemy) service.
     - `SIGNER_ACCOUNT_ADDRESS`: The address of the signer account. This is your whitelisted address on testnet - please file [a ticket](https://discord.com/channels/777248105636560948/1146936525544759457) if you need a new burner wallet registered.
     - `SIGNER_ACCOUNT_PRIVATE_KEY`: The private key corresponding to the signer account address.

3. Open a screen by typing `screen` and then follow instructions by running

    `./build.sh`

    If the `.env` is filled up correctly, all services will execute one by one. The logs do fill up quick. So, remember to [safely detach](https://linuxize.com/post/how-to-use-linux-screen/) from screen when not using it. If you see the following error, your snapshotter address is not registered.

    ```
    deploy-pooler-1           | Snapshotter identity check failed on protocol smart contract
    deploy-pooler-1 exited with code 1
    ```

3. We have setup a bare-bones consensus dashboard at: [testnet-consensus.powerloom.io](https://testnet-consensus.powerloom.io/projects/aggregate_24h_stats_lite:10ecae2f52160690abffff26efeb45568e5d67ea0bc7d4485d9ffb10ef437f33:UNISWAPV2). In a 5-10 minutes, your snapshotter address will start show up - use the search box to filter the results.

4. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](http://localhost:3000) to see a UNISWAPV2 summary data dashboard similar to [PowerLoom UNISWAPV2 Prod](https://uniswapv2.powerloom.io/).
    - A sample screenshot of the dashboard is given [here](./sample_images/pooler-frontend.jpg)

    - Note that the data shown in your own dashboard will not be same as production UI on PowerLoom.io as the "lite mode" is only set to snapshot 7 pair contracts. Refer to contributors section below to enable all pairs.


5. To shutdown services, just press `Ctrl+C` (and again to force).

    > If you don't keep services running for extended periods of time, this will affect consensus and we may be forced to de-activate your snapshotter account.
    
6. If you see issues with data, you can do a clean *reset* by running the following command before restarting step 3:

    `docker-compose --profile ipfs down --volumes`
