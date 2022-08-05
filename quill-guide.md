# Quill Guide
💾 <version>v1.0</version>

## Installation
Suivre la procédure [ici](https://github.com/dfinity/quill) (compiler ou [télécharger une bin](https://github.com/dfinity/quill/releases) déjà prête).

## Syntaxe complète
Copiée de `quill --help`:
```
Ledger & Governance ToolKit for cold wallets

USAGE:
    quill-linux-x86_64 [OPTIONS] <SUBCOMMAND>

OPTIONS:
    -h, --help                         Print help information
        --hsm                          
        --hsm-id <HSM_ID>              
        --hsm-libpath <HSM_LIBPATH>    
        --hsm-slot <HSM_SLOT>          
        --insecure-local-dev-mode      Fetches the root key before making requests so that
                                       interfacing with local instances is possible. DO NOT USE WITH
                                       ANY REAL INFORMATION
        --pem-file <PEM_FILE>          Path to your PEM file (use "-" for STDIN)
        --qr                           Output the result(s) as UTF-8 QR codes
        --seed-file <SEED_FILE>        Path to your seed file (use "-" for STDIN)
    -V, --version                      Print version information

SUBCOMMANDS:
    account-balance             Queries a ledger account balance
    claim-neurons               Claim seed neurons from the Genesis Token Canister
    generate                    Generate a mnemonic seed phrase and generate or recover PEM
    get-neuron-info             
    get-proposal-info           
    help                        Print this message or the help of the given subcommand(s)
    list-neurons                Signs the query for all neurons belonging to the signing
                                    principal
    list-proposals              
    neuron-manage               Signs a neuron configuration change
    neuron-stake                Signs topping up of a neuron (new or existing)
    public-ids                  Prints the principal id and the account id
    qr-code                     Print QR code for data e.g. principal id
    replace-node-provider-id    Signs a message to replace Node Provide ID in targeted Node
                                    Operator Record
    scanner-qr-code             Print QR Scanner dapp QR code: scan to start dapp to submit QR
                                    results
    send                        Sends a signed message or a set of messages
    transfer                    Signs an ICP transfer transaction
    update-node-provider        Update node provider details
```
Pour chaque subcommand, on peut obtenir de l'aide supplémentaire, par exemple pour `send`, taper `quill send --help`.

## Scénarios courants
Pour chaque scénario, un exemple de commande directe est d'abord représenté. La commande utilise des variables, qui permettent d'éviter de devoir taper plusieurs fois les mêmes éléments dans les cas où on aimerait réaliser plusieurs opérations d'affilée.  
Si on a qu'une seule opération à effectuer, on peut simplement entrer les informations à la place du nom de ces variables dans les commandes.

#### Réglage des variables
Taper la commande suivante pour régler une variable contenant le chemin de la clé privée:
```bash
PEM_FILE="cleprivee.pem"
```
Et pour un neuron sur lequel on aimerait faire plusieurs opérations:
```bash
NEURONID=<IDENT>
```
Remplacer `<IDENT>` par le Neuron ID.

### List existing neurons
```bash
quill --pem-file $PEM_FILE list-neurons > /tmp/req.json && quill send --yes /tmp/req.json ; rm /tmp/req.json
```
Il y a en réalité 3 commandes qui sont exécutées:  
1. `quill --pem-file $PEM_FILE list-neurons > /tmp/req.json`: Signe une transaction pour demander une liste des neurons managés par ce compte, et enregistre le résultat dans un fichier temporaire (`/tmp/req.json`).  
2. `quill send --yes /tmp/req.json`: Envoie au résau la transaction signée, et ne demande pas de confirmation (option `--yes`) car c'est une opération peu risquée.  
3. `rm /tmp/req.json`: Supprime le fichier contenant la transaction signée.

L'opérateur `&&`, qui est entre les deux premières commandes, sert à indiquer que le terminal ne doit exécuter la commande suivante que si la précédente a réussi sans erreur. Alors que l'opérateur `;` sert à indiquer que le terminal doit exécuter la commande suivante, une fois la précédente terminée, même si celle-ci a résulté en erreur.

### Stake a new neuron (and set delay)
> ⚠ Non testé !
...

### Generate a hot-key
For monitoring from (https://nns.ic0.app/)
...

### Merge two neurons
...

### Merge maturity from a neuron
...

### Spawn a neuron from maturity
...

### Split a neuron
...

### Increase delay
...

### Increase stake
...

### Participate in community fund
...
