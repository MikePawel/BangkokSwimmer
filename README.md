## Description

This project combines Data retrieval with random state-of-the-art random number generation to store a user's address in combination with the creation block hash, enabling companies to tag users and retrieve even more data from that. A tool that enables tracking and bookkeeping for better analysis

## How it's made

The project uses block hash retrieval from Block scout and Chronical with a random number generator from Pyth network creating the optimal tagging system for all around companies who have data analysis as a feature of data mining in general. The creation can be used as a pludin or integration to streamline the process even on wallet connect => that is how simple it can get for the user integration.
Smart contract development with MultiBaas enabled an even easier smart contract development (Remix was not even working). The static test case site implementation was deployed using BLS Sites Deploy from Blockless

## Deploy locally

```
cd to_repo
npm i
```
then run 
```
npm run dev
```
or deploy locally with blockless
```
sudo sh -c "curl -sSL https://raw.githubusercontent.com/BlocklessNetwork/cli/main/download.sh | bash"
bls login
bls sites build
bls sites preview
```
