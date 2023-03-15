# [Quill](https://medium.com/dfinity/introducing-quill-a-ledger-and-governance-toolkit-for-the-internet-computer-1df086ce5642) staking operations guide
This repository contains a simple guide (in french, to be translated soon in other languages as well) with usual scenarios for [ICP staking](https://medium.com/dfinity/earn-substantial-voting-rewards-by-staking-in-the-network-nervous-system-7eb5cf988182) operations, using [`quill`](https://github.com/dfinity/quill/) [**v0.3.2**](https://github.com/dfinity/quill/releases/tag/v0.3.2).

## Development environment
The source code is a simple markdown file for now.  
Build is realized with `pandoc`, ~~directly from the CI pipeline~~ (not yet!) use the `./build.sh` command to render it in html.

## TODO
Translations.

---
# `neurom` helper script
A simple command line script to help manage neurons from private key files.

## Installation
Copy `neurom.sh` in your local binary folder (for instance `~/.local/bin/` on Debian / Ubuntu), or in a custom `~/binaries/` folder and specify the PATH in your shell config file (`export PATH="${HOME}/binaries:${PATH}"`).

## Usage
Navigate to a folder containing private keys (`.pem` files), and execute `neurom`.  
Follow the instructions given by the script.

## TODO
This script is still in development
