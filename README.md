# README

This is a Polkadot Validator Node Docker Image base on Ubuntu 16.04 (Jelastic PaaS ready) for the POC-3 "BBQ Birch Testnet"

## Docker Build Commands

 * docker build -t=talfco/clb-substrate:latest .
 * docker run --rm -it talfco/clb-substrate:latest substrate
 * docker push talfco/clb-substrate:latest
 
 
 
## Miscellaneous 
* Polkadot DB Location: `/root/.local/share/Substrate/chains` will be mapped to the `/data`
 
 
 
