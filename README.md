# PowerLoom Deployment
Scripts to deploy PowerLoom services (`audit-protocol` and `pooler`) to off chain consensus.

_Note: Access by invitation only for now - please reach out to snapshotters@powerloom.io_

## Requirements

1. Latest version of `docker` and `docker-compose`
2. IPFS daemon (locally or remote instance with API port `5001` tunneled to localhost).
    - While you can run this within docker, we've noticed issues with running on a single system.
    - Regardless, IPFS can hog a lot of resoures - not recommended to run the default setup on a personal computer.
3. RPC URL for Ethereum mainnet. We recommend running a full geth node to save costs but for this phase, any of the following should suffice.
    - [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5) (preferred) __$49/mo__
    - [Infura](https://infura.io) _~$100/mo_ but requires __$225/mo__ plan
    - [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458) __$299/mo__
    - BlockVigil (reach out to us to request a _free_ plan)

## For snapshotters

1. Copy `env.example to .env` and ensure `RPC_URL` and `UUID` is filled.

2. Setup docker to login with your Github:

    - Get your Github personal access token [(classic)](https://github.com/settings/tokens/new). We recommend only giving the `read:packages` permission so this token cannot be abused.

    - Set it in your environment: `export CR_PAT='<personal access token here>'`

    - Login to docker using it: ` echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin`

3. Run the following command and follow instructions

     ./build.sh

## For code contributors

1. Ensure settings and static files are populated on both directories (`../audit-protocol-private` and `../fpmm-pooler-internal`)

2. Run the following command:

     ./build-dev.sh

## Questions?
1. Ask on our [Discord](https://discord.com/channels/777248105636560948/1063022869040353300)
2. Create an [issue](https://github.com/PowerLoom/deploy/issues/new) 
