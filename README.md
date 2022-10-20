# [Quill](https://medium.com/dfinity/introducing-quill-a-ledger-and-governance-toolkit-for-the-internet-computer-1df086ce5642) staking operations guide
This repository contains a simple guide with usual scenarios for [ICP staking](https://medium.com/dfinity/earn-substantial-voting-rewards-by-staking-in-the-network-nervous-system-7eb5cf988182) operations, using [`quill`](https://github.com/dfinity/quill/).

## Development environment
The source code is a simple markdown file for now.  
Build is realized with `pandoc`, directly from the CI pipeline.

## TODO
Scenarios:
- [x] Stake a new neuron (and set delay)
- [x] Generate a hot-key for monitoring from (https://nns.ic0.app/)
- [x] Merge two neurons
- [x] Merge maturity from a neuron
- [x] Spawn a neuron from maturity
- [x] Split a neuron
- [x] Increase delay
- [x] Increase stake
- [x] Participate in community fund

---
# `neurom` helper script
A simple command line script to help manage neurons from private key files.

## Installation
Copy `neurom.sh` in your local binary folder (for instance `~/.local/bin/` on Debian / Ubuntu), or in a custom `~/binaries/` folder and specify the PATH in your shell config file (`export PATH="${HOME}/binaries:${PATH}"`).

## Usage
Navigate to a folder containing private keys (`.pem` files), and execute `neurom`.  
Follow the instructions given by the script.
